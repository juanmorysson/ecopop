import 'package:eco_pop/database/connection.dart';
import 'package:eco_pop/pop/pop.dart';
import 'package:eco_pop/tabvida/tabvida.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference ref = FirebaseDatabase.instance.ref();

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'ecopop');
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(TabVidaDao.tableSql);
      db.execute(TabVidaDao.tableClasseSql);
    },
    version: 1,
    //limpar o banco de dados - primeiro precisa alterar a versão
    //onDowngrade: onDatabaseDowngradeDelete,
  );
}

class TabVidaDao {
  Database? _db;

  static const String _tabela = 'tabvida';
  static const String _id = 'id';
  static const String _descricao = 'descricao';
  static const String _fonte = 'fonte';
  static const String _padrao = 'padrao';

  static const String tableSql = 'CREATE TABLE $_tabela('
      '$_id INTEGER PRIMARY KEY,'
      '$_descricao TEXT,'
      '$_fonte TEXT,'
      '$_padrao BOOLEAN'
      ')';

  static const String _tabelaClasse = 'classe_tabvida';
  static const String _idTabVida = 'id_tabvida';
  static const String _idadeInicio = 'idade_inicio';
  static const String _idadeFim = 'idade_fim';
  static const String _sobreviventes = 'sobreviventes';

  static const String tableClasseSql = 'CREATE TABLE $_tabelaClasse('
      '$_id INTEGER PRIMARY KEY,'
      '$_idTabVida INTEGER,'
      '$_idadeInicio INTEGER,'
      '$_idadeFim INTEGER,'
      '$_sobreviventes INTEGER,'
      ')';


  List<TabVida> _tabVidas = [];
  //salvar
  Future<int> save(TabVida tabVida) async {
    //final Database db = await getDatabase();
    _db = await Connection.getDatabase();

    Map<String, dynamic> tabVidaMap = _toMap(tabVida);
    return _db!.insert(_tabela, tabVidaMap);
  }

  Map<String, dynamic> _toMap(TabVida tabVida) {
    final Map<String, dynamic> tabVidaMap = Map();
    tabVidaMap[_descricao] = tabVida.descricao;
    tabVidaMap[_fonte] = tabVida.fonte;
    tabVidaMap[_padrao] = tabVida.padrao;
    return tabVidaMap;
  }

  //gegar todos
  Future<List<TabVida>> findAll() async {
    //final Database db = await getDatabase();
    _db = await Connection.getDatabase();
    final List<Map<String, dynamic>> resultado = await _db!.query(_tabela);
    List<TabVida> tabVidas = _toList(resultado);
    return tabVidas;
  }

  List<TabVida> _toList(List<Map<String, dynamic>> resultado) {
    final List<TabVida> tabVidas = [];
    for (Map<String, dynamic> row in resultado) {
      final TabVida tabVida = TabVida(
        row[_id],
        row[_descricao],
        "",
        fonte: row[_fonte],
        padrao: row[_padrao],
      );
      tabVidas.add(tabVida);
    }
    return tabVidas;
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
  Future<int> update(TabVida tabVida) async {
    //final db = await getDatabase();
    _db = await Connection.getDatabase();
    final resultado = await _db!.update(_tabela, _toMap(tabVida),
        where: '$_id = ?', whereArgs: [tabVida.id]);
    return resultado;
  }

  //##########FIREBASE
  Future<List<TabVida>> findAllFB(String url) async {
    //Exemplo: url = 'projetos_padrao/EXPO'
    final snapshot = (await ref.child(url).get());
    final List<TabVida> tabVidas = [];
    var i=0;
    while ( i < snapshot.children.length ){
      DataSnapshot data = snapshot.children.elementAt(i);
      final TabVida tabVida = TabVida(
          int.parse(data.child("id").value.toString()),
          data.child("descricao").value.toString(),
          data.key.toString(),
          fonte: data.child("fonte").value.toString(),
          padrao: data.child("padrao").value == 'true'
      );
      tabVidas.add(tabVida);
      i = i +1;
    }
    _tabVidas = tabVidas;
    return tabVidas;
  }

  Future<List<Map<String, dynamic>>> findClassesFB(String url) async {
    final snapshot = (await ref.child(url).get());
    final List<Map<String, dynamic>> dados = [];
    var i=0;
    var estoque = 0;
    while ( i < snapshot.children.length ){
      DataSnapshot data = snapshot.children.elementAt(i);
      print(data.value);
      final Map<String, dynamic> dadosMap = Map();
      var ini = "0";
      var f = "0";
      var s = "0";
      ini = data.child("idade_inicio").value.toString();
      f = data.child("idade_fim").value.toString();
      s = data.child("sobreviventes").value.toString();
      dadosMap['idade_inicio'] = ini;
      dadosMap['idade_fim'] = f;
      dadosMap['sobreviventes'] = s;
      dadosMap['key'] = data.key;
      dados.add(dadosMap);
      i = i +1;
    }
    return dados;
  }
  Future<TabVida> findTabVidaFB(String url) async {
    //Exemplo: url = 'projetos_padrao/EXPO'
    final snapshot = (await ref.child(url).get());
    DataSnapshot data = snapshot;
    final TabVida tabVida = TabVida(
        int.parse(data.child("id").value.toString()),
        data.child("descricao").value.toString(),
        data.key.toString(),
        fonte: data.child("fonte").value.toString(),
        padrao: data.child("padrao").value == 'true'
    );
    print(tabVida);
    return tabVida;
  }

  Future<int> updateFB(TabVida tabVida, String url) async {
    final postData = {
      'id': tabVida.id,
      'descricao':tabVida.descricao,
      'padrao': tabVida.padrao,
      'fonte': tabVida.fonte,
    };
    final Map<String, Map> updates = {};
    final key = tabVida.key;
    updates['$url/$key'] = postData;
    ref.update(updates);
    return 0;
  }

  Future<int> saveFB(TabVida tabVida, String url) async {
    final postData = {
      'id': 0,
      'descricao':tabVida.descricao,
      'padrao': tabVida.padrao,
      'fonte': tabVida.fonte,
    };
    //salva no FB
    final Map<String, Map> updates = {};
    final newPostKey =
        ref.child(url).push().key;
    updates['$url/$newPostKey'] = postData;
    ref.update(updates);
    return 0;
  }

  Future<int> saveClasseFB(ClasseIdadeTabVida dado, String url) async {
    final postData = {
      'id': 0,
      'id_tabvida':dado.idTabVida,
      'idade_inicio':dado.idade_inicio,
      'idade_fim': dado.idade_fim,
      'sobreviventes': dado.sobreviventes,
    };
    //salva no FB
    final Map<String, Map> updates = {};
    final newPostKey =
        ref.child(url).push().key;
    updates['$url/$newPostKey'] = postData;
    ref.update(updates);
    return 0;
  }

  Future<int> deleteClasseFB(String url, String Key) async {
    ref.child(url).child(Key).remove();
    return 0;
  }
}