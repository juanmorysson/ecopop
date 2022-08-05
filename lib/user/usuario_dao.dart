import 'package:eco_pop/database/connection.dart';
import 'package:eco_pop/user/usuario.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/*Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'ecopop');
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(UsuarioDao.tableSql);
    },
    version: 1,
    //limpar o banco de dados - primeiro precisa alterar a versão
    //onDowngrade: onDatabaseDowngradeDelete,
  );
}*/

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference ref = FirebaseDatabase.instance.ref();

class UsuarioDao {
  Database? _db;

  static const String _tabela = 'usuario';
  static const String _id = 'id';
  static const String _email = 'email';
  static const String _displayName = 'display_name';
  static const String _instituicao = 'instituicao';


  static const String tableSql = 'CREATE TABLE $_tabela('
      '$_id INTEGER PRIMARY KEY,'
      '$_email TEXT,'
      '$_displayName TEXT,'
      '$_instituicao TEXT'
      ')';

  //salvar
  Future<int> save(Usuario usuario) async {
    final x = await userForEmail(usuario.email);
    if (x.isNotEmpty){
      usuario = Usuario(x.first.id, usuario.email, usuario.displayName, usuario.instituicao, usuario.key);
      update(usuario);
    }else{
    _db = await Connection.getDatabase();
    Map<String, dynamic> usuarioMap = _toMap(usuario);
    _db!.insert(_tabela, usuarioMap);
    }
    return 0;
  }

  Map<String, dynamic> _toMap(Usuario usuario) {
    final Map<String, dynamic> usuarioMap = Map();
    usuarioMap[_email] = usuario.email;
    usuarioMap[_displayName] = usuario.displayName;
    return usuarioMap;
  }

  Future<Usuario> userForEmailFB(String email) async {
    final snapshot = (await ref.child("usuario").get());
    Usuario user = Usuario(0, "", "", "", "");
    var i = 0;
    while(i < snapshot.children.length){
      DataSnapshot data = snapshot.children.elementAt(i);
      if(data.child("email").value==email){
        user = Usuario(
          0,
          email,
          data.child("displayName").value.toString(),
          data.child("instituicao").value.toString(),
          data.key!,
        );
      }
      i=i+1;
    }
    return user;
  }
  Future<List<Usuario>> userForEmail(String email) async {
    //final Database db = await getDatabase();
    _db = await Connection.getDatabase();
    final List<Map<String, dynamic>> resultado = await _db!.query(_tabela,
        where: "$_email = ?",
        whereArgs: [email]);
    List<Usuario> usuarios = _toList(resultado);
    return usuarios;
  }

  //gegar todos
  Future<List<Usuario>> findAll() async {
    //final Database db = await getDatabase();
    _db = await Connection.getDatabase();
    final List<Map<String, dynamic>> resultado = await _db!.query(_tabela);
    List<Usuario> usuarios = _toList(resultado);
    return usuarios;
  }

  List<Usuario> _toList(List<Map<String, dynamic>> resultado) {
    final List<Usuario> usuarios = [];
    for (Map<String, dynamic> row in resultado) {
      final Usuario usuario = Usuario(
        row[_id],
        row[_email],
        row[_displayName],
        row[_instituicao],
        row[""]
      );
      usuarios.add(usuario);
    }
    return usuarios;
  }

  //delete
  Future<int> delete(int id) async {
    //final db = await getDatabase();
    _db = await Connection.getDatabase();
    int resultado = await _db!.delete(_tabela, //nome da tabela
        where: "$_id = ?",
        whereArgs: [id]);

    return resultado;
  }

  //atualizar
  Future<int> update(Usuario usuario) async {
    //final db = await getDatabase();
    _db = await Connection.getDatabase();
    final resultado = await _db!.update(_tabela, _toMap(usuario),
        where: '$_id = ?', whereArgs: [usuario.id]);
    return resultado;
  }

  Future<int> saveFB(Usuario usuario) async {
    final postData = {
      'id': 0,
      'email': usuario.email,
      'displayName': usuario.displayName,
      'instituicao': usuario.instituicao
    };
    var newPostKey = usuario.key;
    if (usuario.key==""){
      newPostKey =
        ref.child('usuario').push().key;
    }
    //salva no FB
    final Map<String, Map> updates = {};
    updates['/usuario/$newPostKey'] = postData;
    ref.update(updates);
    return 0;
  }
}
