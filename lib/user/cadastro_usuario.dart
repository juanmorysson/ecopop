import 'package:eco_pop/instituicao/instituicao.dart';
import 'package:eco_pop/instituicao/instituicao_dao.dart';
import 'package:eco_pop/user/usuario.dart';
import 'package:eco_pop/user/usuario_dao.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MeusDados extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  State<StatefulWidget> createState() {
    return MeusDadosState();
  }
}

class MeusDadosState extends State<MeusDados> {
  final TextEditingController _email_c = TextEditingController();
  final TextEditingController _nome_c = TextEditingController();
  final TextEditingController _instituicao_c = TextEditingController();
  final InstituicaoDao _instDao = InstituicaoDao();
  final UsuarioDao _userDao = UsuarioDao();
  final _formKey = GlobalKey<FormState>();
  List<Instituicao>? _insts;
  Usuario? _usuario;
  Instituicao? _instituicao = Instituicao(id: 0, descricao: "-0");
  bool selected = false;

  init(GoogleSignInAccount? user) async {
    _insts = await _instDao.findAllFB();
    _usuario = await _userDao.userForEmailFB(user!.email);
    if (_usuario!.email.length != 0){
      _nome_c.text = _usuario!.displayName.toString();
      _instituicao = await _instDao.findFB(_usuario!.instituicao.toString());
      if (_instituicao != null){
        _instituicao_c.text = _instituicao!.uuid.toString();
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount? user =
    ModalRoute
        .of(context)
        ?.settings
        .arguments as GoogleSignInAccount?;
    if (user != null) {
      _email_c.text = user.email.toString();
      _nome_c.text = user.displayName.toString();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Meus Dados'),
        ),
        body: FutureBuilder<dynamic>(
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
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextField(
                        controller: _email_c,
                        decoration: InputDecoration(
                          labelText: 'email',
                          hintText: '@@@',
                        ),
                      ),
                      TextField(
                        controller: _nome_c,
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          hintText: 'seu nome',
                        ),
                      ),
                      DropdownButtonFormField<Instituicao>(
                        value: _instituicao!.descricao == "-0" ? null : _instituicao,
                        icon: const Icon(Icons.arrow_downward),
                        hint: const Text('Selecione a Instituição'),
                        elevation: 16,
                        onChanged: (Instituicao? instituicao) {
//                          setState(() {
                            _instituicao_c.text = instituicao!.uuid.toString();
                            this._instituicao = instituicao;
//                          });
                        },
                        items: _insts!
                            .map<DropdownMenuItem<Instituicao>>((Instituicao item) {
                          return DropdownMenuItem<Instituicao>(
                            value: item,
                            child: Text(item.descricao),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Você deve selecionar...';
                          }
                          return null;
                        },
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final Usuario usuarioCD = Usuario(
                                  0, _email_c.text, _nome_c.text, _instituicao_c.text,
                                  _usuario!.key);
                              _userDao.saveFB(usuarioCD)
                                  .then((id) => Navigator.pop(context));
                            }
                          },
                          child: Text('Confirmar'),
                        ),
                      ),
                    ],
                  ),
                );
            }
            return Text('Unknown error');
          },
        )
    );
  }
}
