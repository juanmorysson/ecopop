import 'package:eco_pop/database/connection.dart';
import 'package:eco_pop/comp/comp.dart';
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
      db.execute(CompDao.tableSql);
      db.execute(CompDao.tableDadosSql);
    },
    version: 1,
    //limpar o banco de dados - primeiro precisa alterar a versão
    //onDowngrade: onDatabaseDowngradeDelete,
  );
}

class CompDao {
  Database? _db;

  static const String _tabela = 'comp';
  static const String _id = 'id';
  static const String _descricao = 'descricao';
  static const String _fonte = 'fonte';
  static const String _padrao = 'padrao';
  static const String _especie_a = 'especie_a';
  static const String _especie_b = 'especie_b';

  static const String tableSql = 'CREATE TABLE $_tabela('
      '$_id INTEGER PRIMARY KEY,'
      '$_descricao TEXT,'
      '$_fonte TEXT,'
      '$_especie_a TEXT,'
      '$_especie_b TEXT,'
      '$_padrao BOOLEAN'
      ')';

  static const String _tabelaDados = 'dados_comp';
  static const String _idComp = 'id_comp';
  static const String _qtd_especie_a = 'qtd_especie_a';
  static const String _qtd_especie_b = 'qtd_especie_b';
  static const String _tempo = 'tempo';

  static const String tableDadosSql = 'CREATE TABLE $_tabelaDados('
      '$_id INTEGER PRIMARY KEY,'
      '$_idComp INTEGER,'
      '$_qtd_especie_a INTEGER,'
      '$_qtd_especie_b INTEGER,'
      '$_tempo INTEGER,'
      ')';


  List<Comp> _comps = [];
  //salvar
  Future<int> save(Comp comp) async {
    //final Database db = await getDatabase();
    _db = await Connection.getDatabase();

    Map<String, dynamic> compMap = _toMap(comp);
    return _db!.insert(_tabela, compMap);
  }

  Map<String, dynamic> _toMap(Comp comp) {
    final Map<String, dynamic> compMap = Map();
    compMap[_descricao] = comp.descricao;
    compMap[_fonte] = comp.fonte;
    compMap[_especie_a] = comp.especie_a;
    compMap[_especie_b] = comp.especie_b;
    compMap[_padrao] = comp.padrao;
    return compMap;
  }

  //gegar todos
  Future<List<Comp>> findAll() async {
    //final Database db = await getDatabase();
    _db = await Connection.getDatabase();
    final List<Map<String, dynamic>> resultado = await _db!.query(_tabela);
    List<Comp> comps = _toList(resultado);
    return comps;
  }

  List<Comp> _toList(List<Map<String, dynamic>> resultado) {
    final List<Comp> comps = [];
    for (Map<String, dynamic> row in resultado) {
      final Comp comp = Comp(
        row[_id],
        row[_descricao],
        "",
        row[_especie_a],
        row[_especie_b],
        fonte: row[_fonte],
        padrao: row[_padrao],
      );
      comps.add(comp);
    }
    return comps;
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
  Future<int> update(Comp comp) async {
    //final db = await getDatabase();
    _db = await Connection.getDatabase();
    final resultado = await _db!.update(_tabela, _toMap(comp),
        where: '$_id = ?', whereArgs: [comp.id]);
    return resultado;
  }

  //##########FIREBASE
  Future<List<Comp>> findAllFB(String url) async {
    //Exemplo: url = 'projetos_padrao/EXPO'
    final snapshot = (await ref.child(url).get());
    final List<Comp> comps = [];
    var i=0;
    while ( i < snapshot.children.length ){
      DataSnapshot data = snapshot.children.elementAt(i);
      print(data.child("especie_a").value.toString());
      final Comp comp = Comp(
          int.parse(data.child("id").value.toString()),
          data.child("descricao").value.toString(),
          data.child("especie_a").value.toString(),
          data.child("especie_b").value.toString(),
          data.key.toString(),
          fonte: data.child("fonte").value.toString(),
          padrao: data.child("padrao").value == 'true'
      );
      comps.add(comp);
      i = i +1;
    }
    _comps = comps;
    return comps;
  }

  Future<List<Map<String, dynamic>>> findDadosFB(String url) async {
    final snapshot = (await ref.child(url).get());
    final List<Map<String, dynamic>> dados = [];
    var i=0;
    while ( i < snapshot.children.length ){
      DataSnapshot data = snapshot.children.elementAt(i);
      final Map<String, dynamic> dadosMap = Map();
      var a = "0";
      var b = "0";
      var t = "0";
      a = data.child("qtd_especie_a").value.toString();
      b = data.child("qtd_especie_b").value.toString();
      t = data.child("tempo").value.toString();
      dadosMap['qtd_especie_a'] = a;
      dadosMap['qtd_especie_b'] = b;
      dadosMap['tempo'] = t;
      dadosMap['key'] = data.key;
      dados.add(dadosMap);
      i = i +1;
    }
    return dados;
  }
  Future<Comp> findCompFB(String url) async {
    //Exemplo: url = 'projetos_padrao/EXPO'
    final snapshot = (await ref.child(url).get());
    DataSnapshot data = snapshot;
    final Comp comp = Comp(
        int.parse(data.child("id").value.toString()),
        data.child("descricao").value.toString(),
        data.child("especie_a").value.toString(),
        data.child("especie_b").value.toString(),
        data.key.toString(),
        fonte: data.child("fonte").value.toString(),
        padrao: data.child("padrao").value == 'true',
    );
    print(comp);
    return comp;
  }

  Future<int> updateFB(Comp comp, String url) async {
    final Map<String, Map> updates = {};
    final key = comp.key;
    Object? dados = "";
    final snapshot = (await ref.child("$url/$key/dados").get());
    dados = snapshot.value;
    final postData = {
      'id': comp.id,
      'descricao':comp.descricao,
      'padrao': comp.padrao,
      'fonte': comp.fonte,
      'especie_a': comp.especie_a,
      'especie_b': comp.especie_b,
      'dados': dados
    };
    updates['$url/$key'] = postData;
    ref.update(updates);
    return 0;
  }

  Future<int> saveFB(Comp comp, String url) async {
    final postData = {
      'id': 0,
      'descricao':comp.descricao,
      'padrao': comp.padrao,
      'fonte': comp.fonte,
      'especie_a': comp.especie_a,
      'especie_b': comp.especie_b,
    };
    //salva no FB
    final Map<String, Map> updates = {};
    final newPostKey =
        ref.child(url).push().key;
    updates['$url/$newPostKey'] = postData;
    ref.update(updates);
    return 0;
  }

  Future<int> saveDadosFB(DadosComp dado, String url) async {
    final postData = {
      'id': 0,
      'id_comp':dado.idComp,
      'qtd_especie_a':dado.qtd_especie_a,
      'qtd_especie_b': dado.qtd_especie_b,
      'tempo': dado.tempo,
    };
    //salva no FB
    final Map<String, Map> updates = {};
    final newPostKey =
        ref.child(url).push().key;
    updates['$url/$newPostKey'] = postData;
    ref.update(updates);
    return 0;
  }

  Future<int> deleteDadosFB(String url, String Key) async {
    ref.child(url).child(Key).remove();
    return 0;
  }
}