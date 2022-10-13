import 'package:eco_pop/grupo-pesquisa/cadastro_grupo.dart';
import 'package:eco_pop/grupo-pesquisa/grupo.dart';
import 'package:eco_pop/grupo-pesquisa/grupo_dao.dart';
import 'package:eco_pop/pop/cadastro_dados_pop.dart';
import 'package:eco_pop/pop/cadastro_pop.dart';
import 'package:eco_pop/pop/lista_pop.dart';
import 'package:eco_pop/pop/pop.dart';
import 'package:eco_pop/pop/pop_dao.dart';
import 'package:eco_pop/pop/pop_view.dart';
import 'package:eco_pop/tabvida/lista_tabvida.dart';
import 'package:eco_pop/user/usuario.dart';
import 'package:eco_pop/user/usuario_dao.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ListarTipoProjs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListarTipoProjsState();
  }
}

class ListarTipoProjsState extends State<ListarTipoProjs> {
  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount? user =
        ModalRoute.of(context)?.settings.arguments as GoogleSignInAccount?;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Tipo de Projeto'),
      ),
      body: ListView(
        children: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => ListarPop(),
                      settings: RouteSettings(arguments: user),
                    ),
                  )
                  .then(
                    (value) => setState(() {}),
                  );
            },
            child: Card(
              child: ListTile(
                title: Text("Pop"),
                subtitle: Text("Projeto de Crescimento Populacional"),
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => ListarTabVida(),
                  settings: RouteSettings(arguments: user),
                ),
              )
                  .then(
                    (value) => setState(() {}),
              );
            },
            child: Card(
              child: ListTile(
                title: Text("TabVida"),
                subtitle: Text("Projeto de Tebla de Vida"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
