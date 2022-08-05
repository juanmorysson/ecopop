import 'package:eco_pop/grupo-pesquisa/cadastro_grupo.dart';
import 'package:eco_pop/grupo-pesquisa/grupo.dart';
import 'package:eco_pop/grupo-pesquisa/grupo_dao.dart';
import 'package:eco_pop/pop/cadastro_pop.dart';
import 'package:eco_pop/pop/pop.dart';
import 'package:eco_pop/pop/pop_dao.dart';
import 'package:eco_pop/pop/pop_view.dart';
import 'package:eco_pop/user/usuario.dart';
import 'package:eco_pop/user/usuario_dao.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ListarPop extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListarPopState();
  }
}

class ListarPopState extends State<ListarPop> {
  final PopDao _popDao = PopDao();
  final UsuarioDao _userDao = UsuarioDao();
  List<Pop>? _pops;
  Usuario? _usuario;
  String? url;
  bool ver = true;

  init(GoogleSignInAccount? user) async {
    if(user!=null) {
      _usuario = await _userDao.userForEmailFB(user.email);
      var key = _usuario!.key;
      url = 'usuario/$key/projetos/';
      _pops = await _popDao.findAllFB(url!);
    }else{
      _pops = await _popDao.findAllFB('projetos_padrao');
      ver = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount? user =
    ModalRoute.of(context)?.settings.arguments as GoogleSignInAccount?;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Crescimento Populacional'),
      ),
      body: FutureBuilder<dynamic>(
        initialData: [],
        future: init(user),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text('Carregando!')
                  ],
                ),
              );
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              return ListView.builder(
                itemBuilder: (context, index) {
                  final Pop pop = _pops![index];
                  //return ItensGruposPesquisa(grupo);
                  return MaterialButton(
                    onPressed: () {},
                    child: Card(
                      child: ListTile(
                        title: Text(pop.descricao),
                        subtitle: Text(pop.experimento.toString()),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            children: <Widget>[
                              Visibility(
                                visible: !ver,
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              VerPop(),
                                          settings:
                                          RouteSettings(arguments: pop),
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
                                      Navigator.of(context)
                                          .push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              VerPop(),
                                          settings:
                                          RouteSettings(arguments: pop),
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
                                      args.add(pop);
                                      args.add(url!);
                                      Navigator.of(context)
                                          .push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FormularioPop(),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: _pops!.length,
              );
              break;
          }
          return Text('Unknown error');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          List<Object> args = [];
          Pop? fakepop = Pop(0, "", "-0");
          args.add(fakepop);
          args.add(url!);
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => FormularioPop(),
                  settings: RouteSettings(arguments: args),
                ),
              )
              .then(
                (value) => setState(() {}),
              );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
