import 'dart:async';

import 'package:eco_pop/instituicao/lista_instituicao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eco_pop/page_inicial.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'grupo-pesquisa/lista_grupo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]);
  runApp(
      MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.green
    ),
    home: const Splash(),
    // home: ListarGruposPesquisa()
  ));
}

class Connection {
  static Database? _db;

  static Future<Database?> get() async {
    if (_db == null) {
      var path = join(await getDatabasesPath(), 'ecopop');
      //deleteDatabase(path);
      _db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, v) {
          db.execute(createTable);
          db.execute(insert1);
          //db.execute(insert2);
          //db.execute(insert3);
        },
      );
    }
    return _db;
  }
}

final createTable = '''
  CREATE TABLE grupo(
    id INTEGER NOT NULL PRIMARY KEY
    ,grupo VARCHAR(200) NOT NULL
  )
''';

final insert1 = '''
  INSERT INTO grupo (grupo)
  VALUES ('anatormia dos vegetais')
''';
