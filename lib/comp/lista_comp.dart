import 'package:eco_pop/comp/cadastro_comp.dart';
import 'package:eco_pop/comp/cadastro_dados_comp.dart';
import 'package:eco_pop/comp/comp.dart';
import 'package:eco_pop/comp/comp_dao.dart';
import 'package:eco_pop/comp/comp_view.dart';
import 'package:eco_pop/user/usuario.dart';
import 'package:eco_pop/user/usuario_dao.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ListarComp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListarCompState();
  }
}

class ListarCompState extends State<ListarComp> {
  final CompDao _compDao = CompDao();
  final UsuarioDao _userDao = UsuarioDao();
  List<Comp>? _comps;
  Usuario? _usuario;
  String? url;
  bool ver = true;

  init(GoogleSignInAccount? user) async {
    if(user!=null) {
      _usuario = await _userDao.userForEmailFB(user.email);
      var key = _usuario!.key;
      url = 'usuario/$key/projetos/comp/';
      _comps = await _compDao.findAllFB(url!);
    }else{
      url = 'projetos_padrao/comp/';
      _comps = await _compDao.findAllFB(url!);
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
                title: Text('Competição / Predação'),
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
                  title: Text('Competição / Predação'),
                ),
                body:  ListView.builder(
                  itemBuilder: (context, index) {
                    final Comp comp = _comps![index];
                    //return ItensGruposPesquisa(grupo);
                    return MaterialButton(
                      onPressed: () {},
                      child: Card(
                        child: ListTile(
                          title: Text(comp.descricao),
                          subtitle: Text("Espécies: "+comp.especie_a.toString()+ " X "+comp.especie_b.toString()),
                          trailing: Container(
                            width: 145,
                            child: Row(
                              children: <Widget>[
                                Visibility(
                                  visible: !ver,
                                  child: IconButton(
                                      onPressed: () {
                                        List<Object> args = [];
                                        args.add(comp);
                                        args.add(url!);

                                        Navigator.of(context)
                                            .push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                VerComp(),
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
                                        args.add(comp);
                                        args.add(url!);
                                        Navigator.of(context)
                                            .push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FormDadosComp(),
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
                                        args.add(comp);
                                        args.add(url!);
                                        Navigator.of(context)
                                            .push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FormularioComp(),
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
                                          args.add(comp);
                                          args.add(url!);
                                          Navigator.of(context)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  VerComp(),
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
                  itemCount: _comps!.length,
               ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  List<Object> args = [];
                  Comp? faketab = Comp(0, "","","", "-0");
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
                        builder: (context) => FormularioComp(),
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
