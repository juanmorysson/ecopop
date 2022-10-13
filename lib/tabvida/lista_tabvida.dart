import 'package:eco_pop/pop/cadastro_dados_pop.dart';
import 'package:eco_pop/pop/cadastro_pop.dart';
import 'package:eco_pop/pop/pop.dart';
import 'package:eco_pop/pop/pop_dao.dart';
import 'package:eco_pop/pop/pop_view.dart';
import 'package:eco_pop/tabvida/cadastro_classe_tabvida.dart';
import 'package:eco_pop/tabvida/cadastro_tabvida.dart';
import 'package:eco_pop/tabvida/tabvida.dart';
import 'package:eco_pop/tabvida/tabvida_dao.dart';
import 'package:eco_pop/tabvida/tabvida_view.dart';
import 'package:eco_pop/user/usuario.dart';
import 'package:eco_pop/user/usuario_dao.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ListarTabVida extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListarTabVidaState();
  }
}

class ListarTabVidaState extends State<ListarTabVida> {
  final TabVidaDao _tabVidaDao = TabVidaDao();
  final UsuarioDao _userDao = UsuarioDao();
  List<TabVida>? _tabs;
  Usuario? _usuario;
  String? url;
  bool ver = true;

  init(GoogleSignInAccount? user) async {
    if(user!=null) {
      _usuario = await _userDao.userForEmailFB(user.email);
      var key = _usuario!.key;
      url = 'usuario/$key/projetos/tab/';
      _tabs = await _tabVidaDao.findAllFB(url!);
    }else{
      url = 'projetos_padrao/tab/';
      _tabs = await _tabVidaDao.findAllFB(url!);
      ver = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount? user =
    ModalRoute.of(context)?.settings.arguments as GoogleSignInAccount?;
    return FutureBuilder<dynamic>(
      initialData: [],
      future: init(user),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text('Tabela de Vida'),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text('Carregando!')
                  ],
                ),
              )
            );
            break;
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text('Tabela de Vida'),
                ),
                body:  ListView.builder(
                  itemBuilder: (context, index) {
                    final TabVida tab = _tabs![index];
                    //return ItensGruposPesquisa(grupo);
                    return MaterialButton(
                      onPressed: () {},
                      child: Card(
                        child: ListTile(
                          title: Text(tab.descricao),
                          subtitle: Text(tab.fonte.toString()),
                          trailing: Container(
                            width: 145,
                            child: Row(
                              children: <Widget>[
                                Visibility(
                                  visible: !ver,
                                  child: IconButton(
                                      onPressed: () {
                                        List<Object> args = [];
                                        args.add(tab);
                                        args.add(url!);

                                        Navigator.of(context)
                                            .push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                VerTabVida(),
                                            settings:
                                            RouteSettings(arguments: args),
                                          ),
                                        )
                                            .then(
                                              (value) => setState(() {}),
                                        );
                                      },
                                      icon: Icon(Icons.art_track),
                                      color: Colors.orange[300]
                                  ),
                                ),
                                Visibility(
                                  visible: ver,
                                  child: IconButton(
                                      onPressed: () {
                                        List<Object> args = [];
                                        args.add(tab);
                                        args.add(url!);
                                        Navigator.of(context)
                                            .push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FormClasseTabVida(),
                                            settings:
                                            RouteSettings(arguments: args),
                                          ),
                                        )
                                            .then(
                                              (value) => setState(() {}),
                                        );
                                      },
                                      icon: Icon(Icons.data_array_sharp),
                                      color: Colors.orange[300])
                                ),
                                Visibility(
                                  visible: ver,
                                  child: IconButton(
                                      onPressed: () {
                                        List<Object> args = [];
                                        args.add(tab);
                                        args.add(url!);
                                        Navigator.of(context)
                                            .push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FormularioTabVida(),
                                            settings:
                                            RouteSettings(arguments: args),
                                          ),
                                        )
                                            .then(
                                              (value) => setState(() {}),
                                        );
                                      },
                                      icon: Icon(Icons.edit),
                                      color: Colors.orange[300])
                                ),
                                Visibility(
                                    visible: ver,
                                    child: IconButton(
                                        onPressed: () {
                                          List<Object> args = [];
                                          args.add(tab);
                                          args.add(url!);
                                          Navigator.of(context)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  VerTabVida(),
                                              settings:
                                              RouteSettings(arguments: args),
                                            ),
                                          )
                                              .then(
                                                (value) => setState(() {}),
                                          );
                                        },
                                        icon: Icon(Icons.art_track),
                                        color: Colors.orange[300])
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: _tabs!.length,
               ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  List<Object> args = [];
                  TabVida? faketab = TabVida(0, "", "-0");
                  args.add(faketab);
                  args.add(url!);
                  if(_usuario!.key==""){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Você precisa confirmar seus dados no menu inicial!"),
                    ));
                  }else {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => FormularioTabVida(),
                        settings: RouteSettings(arguments: args),
                      ),
                    )
                        .then(
                          (value) => setState(() {}),
                    );
                  }
                },
                child: Icon(Icons.add),
              ),
            );
            break;
        }
        return Text('Unknown error');
      },
    );
  }
}
