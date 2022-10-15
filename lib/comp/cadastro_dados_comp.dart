import 'package:eco_pop/pop/pop.dart';
import 'package:eco_pop/pop/pop_dao.dart';
import 'package:eco_pop/pop/pop_view.dart';
import 'package:eco_pop/comp/comp.dart';
import 'package:eco_pop/comp/comp_dao.dart';
import 'package:eco_pop/comp/comp_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FormDadosComp extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  State<StatefulWidget> createState() {
    return FormDadosCompState();
  }
}

class FormDadosCompState extends State<FormDadosComp> {
  final TextEditingController _a_c = TextEditingController();
  final TextEditingController _b_c = TextEditingController();
  final TextEditingController _t_c = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final CompDao _compDao = CompDao();

  @override
  Widget build(BuildContext context) {
    List<Object> args =
    ModalRoute.of(context)?.settings.arguments as List<Object>;
    final Comp? comp = args[0] as Comp?;
    final String? url = args[1] as String;
    var keyTab = comp!.key.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('Dados - Projeto CompPred'),
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
                        title: Text(comp!=null?comp.descricao:""),
                        subtitle: Text(comp!=null?"Esécies: "+comp.especie_a.toString()+" X "+comp.especie_b.toString():"")
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
                    controller: _a_c,
                    decoration: InputDecoration(
                      labelText: 'Qtd A',
                      hintText: '',
                    ),
                  ),
                  width: MediaQuery.of(context).size.width*0.32,
                ),
                SizedBox(
                  child: TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    controller: _b_c,
                    decoration: InputDecoration(
                      labelText: 'Qtd B',
                      hintText: '',
                    ),
                  ),
                  width: MediaQuery.of(context).size.width*0.32,
                ),
                SizedBox(
                  child: TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    controller: _t_c,
                    decoration: InputDecoration(
                      labelText: 'Tempo',
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
                      final DadosComp classeCD = DadosComp(
                          0,
                          comp.id,
                          int.parse(_a_c.text),
                          int.parse(_b_c.text),
                          int.parse(_t_c.text),
                      );
                      //update
                      _compDao
                          .saveDadosFB(classeCD, '$url$keyTab/dados')
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
                    width: MediaQuery.of(context).size.width*0.22,
                    child: Text(comp.especie_a.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.22,
                    child: Text(comp.especie_b.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.22,
                    child: Text("Tempo", style: TextStyle(fontWeight: FontWeight.bold)),
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
                  future: _compDao.findDadosFB('$url$keyTab/dados'),
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
                                      width: MediaQuery.of(context).size.width*0.22,
                                      child: Text(dados.elementAt(index)['qtd_especie_a'], style: TextStyle(color: Colors.black),),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.22,
                                      child: Text(dados.elementAt(index)['qtd_especie_b'], style: TextStyle(color: Colors.black),),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.22,
                                      child: Text(dados.elementAt(index)['tempo'], style: TextStyle(color: Colors.black),),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.17,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(()  {
                                            _compDao.deleteDadosFB('$url$keyTab/comp', dados.elementAt(index)['key']);
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
