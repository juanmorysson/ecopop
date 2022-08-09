import 'package:eco_pop/info.dart';
import 'package:eco_pop/instituicao/lista_instituicao.dart';
import 'package:eco_pop/page_inicial.dart';
import 'package:eco_pop/pop/lista_pop.dart';
import 'package:eco_pop/user/cadastro_usuario.dart';
import 'package:eco_pop/utils/network_status_service.dart';
import 'package:eco_pop/utils/teste_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

bool _online = true;


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignInAccount? _currentUser;
  String _contactText = '';
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        //_handleGetContact(_currentUser!);
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'lendo informações sobre o contato';
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = 'A API deu uma resposta ${response.statusCode} '
            '. Verifique os logs para obter detalhes.';
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
    json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = 'Você é... $namedContact!';
      } else {
        _contactText = 'Nada para exibir.';
      }
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
          (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final Map<String, dynamic>? name = contact['names'].firstWhere(
            (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    _online = await hasNetwork();
    try {
      var user1 = await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('eCoPoP'),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed:() {
          //sobre o projeto
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) =>
                  //Splash(),
                  Info(),
                  //MyHomePage(title: "teste"),
              settings:
              RouteSettings(arguments: null),
            ),
          )
              .then(
                (value) => setState(() {}),
          );
        },
        backgroundColor: Colors.lightGreen[400],
        child: Icon(Icons.info, size: MediaQuery.of(context).size.height*0.04),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
  }

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      return Column(
          children: [
            SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.16,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.78,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.13,
                            child: ListTile(
                              leading: GoogleUserCircleAvatar(
                                identity: user,
                              ),
                              title: Text(user.displayName ?? ''),
                              subtitle: Text(user.email),
                            ),

                        ),
                        FloatingActionButton(
                          onPressed: _handleSignOut,
                          backgroundColor: Colors.green,
                          child: Icon(Icons.logout),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),//0.16
            Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.02)), //0.02
            SizedBox(
              width: MediaQuery.of(context).size.width*0.8,
              height: MediaQuery.of(context).size.height*0.02,
              child: Text("Menu:", textAlign: TextAlign.right),
            ), //0.02
            Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.02)), //0.02
            SizedBox(
              height: MediaQuery.of(context).size.height*0.24,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.4,
                    height: MediaQuery
                        .of(context)
                        .size
                        .width * 0.4,
                    child: FloatingActionButton(
                      onPressed:() {
                        final Future future =
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return ListarPop();
                        }));
                        future.then((grupo) {
                          //teste
                        });
                      },
                      backgroundColor: Colors.lightGreen[900],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.document_scanner, size: MediaQuery
                            .of(context)
                            .size
                            .width * 0.2),
                          Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.02)),
                          Text("Projetos Públicos")
                        ],
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(right: MediaQuery
                      .of(context)
                      .size
                      .width * 0.05)),
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.4,
                    height: MediaQuery
                        .of(context)
                        .size
                        .width * 0.4,
                    child: FloatingActionButton(
                      onPressed:() {
                        final Future future =
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ListarPop(),
                          settings: RouteSettings(arguments: user),
                        ));
                        future.then((grupo) {
                          //teste
                        });
                      },
                      backgroundColor: Colors.lightGreen,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.document_scanner, size: MediaQuery
                              .of(context)
                              .size
                              .width * 0.2),
                          Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.02)),
                          Text("Meus Projetos")
                        ],
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                    ),
                  ),
                ],
              ),
            ), //0.24
            Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.02)), //0.02
            SizedBox(
              width: MediaQuery.of(context).size.width*0.8,
              height: MediaQuery.of(context).size.height*0.24,
              child:             Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Cadastros:"),
                  Padding(padding: EdgeInsets.only(bottom: 8.0)),
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.6,
                    height: 50,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        final Future future =
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MeusDados(),
                          settings: RouteSettings(arguments: _currentUser),
                        ));
                        future.then((usuario) {
                          //teste
                        });
                      },
                      label: const Text("Meus Dados"),
                      backgroundColor: Colors.amber,
                      icon: Icon(Icons.account_box),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 8.0)),
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.6,
                    height: 50,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        final Future future =
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return ListarInstituicao();
                        }));
                        future.then((instituicao) {});
                      },
                      label: const Text("Instituição"),
                      backgroundColor: Color.fromRGBO(204, 153, 51, 1),
                      icon: Icon(Icons.account_balance),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                    ),
                  ),

                ],
              ),
            ), //0.24
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.height*0.16,
                    height: MediaQuery.of(context).size.height*0.16,
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        alignment: Alignment.center,
                        image: AssetImage('assets/ecopop.png'),
                      ), //AssetImage("assets/Serenity.png"),
                    ),
                  ),
              ],
            )

          ]);
    } else {
      return Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.height*0.14,
                    height: MediaQuery.of(context).size.height*0.14,
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        alignment: Alignment.center,
                        image: AssetImage('assets/ecopop.png'),
                      ), //AssetImage("assets/Serenity.png"),
                    ),
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  FloatingActionButton.extended(
                    onPressed: _handleSignIn,
                    label: Text(
                      "Entrar",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                  ),
                ]),
          )); // This trailing comma makes auto-formatting nicer for build methods.
    }
  }
}
