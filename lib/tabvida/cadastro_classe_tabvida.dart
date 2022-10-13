import 'package:eco_pop/pop/pop.dart';
import 'package:eco_pop/pop/pop_dao.dart';
import 'package:eco_pop/pop/pop_view.dart';
import 'package:eco_pop/tabvida/tabvida.dart';
import 'package:eco_pop/tabvida/tabvida_dao.dart';
import 'package:eco_pop/tabvida/tabvida_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FormClasseTabVida extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  State<StatefulWidget> createState() {
    return FormClasseTabVidaState();
  }
}

class FormClasseTabVidaState extends State<FormClasseTabVida> {
  final TextEditingController _i_c = TextEditingController();
  final TextEditingController _f_c = TextEditingController();
  final TextEditingController _s_c = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TabVidaDao _tabVidaDao = TabVidaDao();

  @override
  Widget build(BuildContext context) {
    List<Object> args =
    ModalRoute.of(context)?.settings.arguments as List<Object>;
    final TabVida? tab = args[0] as TabVida?;
    final String? url = args[1] as String;
    var keyTab = tab!.key.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('Classes - Projeto Tab Vida'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 20.0),
        child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.96,
                  child: Card(
                    child: ListTile(
                        title: Text(tab!=null?tab.descricao:""),
                        subtitle: Text(tab!=null?tab.fonte.toString():"")
                    ),
                  ),
                ),

              ],
            ),

            Row(
              children: [
                SizedBox(
                  child: TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    controller: _i_c,
                    decoration: InputDecoration(
                      labelText: 'Idade Início',
                      hintText: '',
                    ),
                  ),
                  width: MediaQuery.of(context).size.width*0.32,
                ),
                SizedBox(
                  child: TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    controller: _f_c,
                    decoration: InputDecoration(
                      labelText: 'Idade Final',
                      hintText: '',
                    ),
                  ),
                  width: MediaQuery.of(context).size.width*0.32,
                ),
                SizedBox(
                  child: TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    controller: _s_c,
                    decoration: InputDecoration(
                      labelText: 'Sobreviventes',
                      hintText: '',
                    ),
                  ),
                  width: MediaQuery.of(context).size.width*0.31,
                ),

              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                      final ClasseIdadeTabVida classeCD = ClasseIdadeTabVida(
                          0,
                          tab.id,
                          int.parse(_i_c.text),
                          int.parse(_f_c.text),
                          int.parse(_s_c.text),
                      );
                      //update
                      _tabVidaDao
                          .saveClasseFB(classeCD, '$url$keyTab/classes')
                          .then(
                              //(id) => Navigator.pop(context)
                          (id) => setState((){})
                      );
                    }
                },
                child: Text('Adicionar'),
              ),
            ),
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.45,
                    child: Text("Classe", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.30,
                    child: Text("Sobreviventes", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.17,
                    child: Text("", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height*0.5,
              child:
               FutureBuilder<List<Map<String, dynamic>>>(
                  initialData: [],
                  future: _tabVidaDao.findClassesFB('$url$keyTab/classes'),
                  builder: (context, snapshot) {
                    final List<Map<String, dynamic>> dados = snapshot.data ?? [];
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
                            shrinkWrap: true,
                            itemCount: dados.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return new Card(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.45,
                                      child: Text("De "+dados.elementAt(index)['idade_inicio']+" até "+dados.elementAt(index)['idade_fim'], style: TextStyle(color: Colors.black),),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.30,
                                      child: Text(dados.elementAt(index)['sobreviventes'], style: TextStyle(color: Colors.black),),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.17,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(()  {
                                            _tabVidaDao.deleteClasseFB('$url$keyTab/classes', dados.elementAt(index)['key']);
                                          });
                                        },
                                        icon: Icon(Icons.delete, size: 18.0),
                                        color: Colors.red[900],
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                        );
                    }
                    return Text('Unknown error');
                  },),

            )


          ],
        ),
        )
      )

    );
  }


  String? _validarNome(String value) {
    if (value.length == 0) {
      return "Campo obrigatório";
    }

    return null;
  }
}
