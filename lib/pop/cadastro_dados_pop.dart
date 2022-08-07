import 'package:eco_pop/pop/pop.dart';
import 'package:eco_pop/pop/pop_dao.dart';
import 'package:eco_pop/pop/pop_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FormDadosPop extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  State<StatefulWidget> createState() {
    return FormDadosPopState();
  }
}

class FormDadosPopState extends State<FormDadosPop> {
  final TextEditingController _t_c = TextEditingController();
  final TextEditingController _b_c = TextEditingController();
  final TextEditingController _d_c = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final PopDao _popDao = PopDao();

  @override
  Widget build(BuildContext context) {
    List<Object> args =
    ModalRoute.of(context)?.settings.arguments as List<Object>;
    final Pop? pop = args[0] as Pop?;
    final String? url = args[1] as String;
    var keyPop = pop!.key.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('Ddaos - Projeto Pop'),
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
                  width: MediaQuery.of(context).size.width*0.80,
                  child: Card(
                    child: ListTile(
                        title: Text(pop!=null?pop.descricao:""),
                        subtitle: Text(pop!=null?pop.experimento.toString():"")
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.15,
                  child: IconButton(
                      onPressed: () {
                        List<Object> args = [];
                        args.add(pop);
                        args.add(url!);
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) =>
                                VerPop(),
                            settings:
                            RouteSettings(arguments: args),
                          ),
                        )
                            .then(
                              (value) => setState(() {}),
                        );
                      },
                      icon: Icon(Icons.art_track, size: 42.0),
                      color: Colors.orange[300]
                  ),
                )
              ],
            ),

            Row(
              children: [
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
                  width: MediaQuery.of(context).size.width*0.32,
                ),
                SizedBox(
                  child: TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    controller: _b_c,
                    decoration: InputDecoration(
                      labelText: 'Nasc.',
                      hintText: '',
                    ),
                  ),
                  width: MediaQuery.of(context).size.width*0.32,
                ),
                SizedBox(
                  child: TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    controller: _d_c,
                    decoration: InputDecoration(
                      labelText: 'Mortes',
                      hintText: '',
                    ),
                  ),
                  width: MediaQuery.of(context).size.width*0.31,
                )
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                      final DadosPop dadoCD = DadosPop(
                          0,
                          pop.id,
                          double.parse(_d_c.text),
                          double.parse(_b_c.text),
                          double.parse(_t_c.text),
                          );
                      //update
                      _popDao
                          .saveDadoFB(dadoCD, '$url$keyPop/dados')
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
                    width: MediaQuery.of(context).size.width*0.17,
                    child: Text("Tempo", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.17,
                    child: Text("Nasci..", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.17,
                    child: Text("Mortes", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.17,
                    child: Text("Estoque", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.15,
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
                  future: _popDao.findDadosFB('$url$keyPop/dados'),
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
                                      width: MediaQuery.of(context).size.width*0.17,
                                      child: Text(dados.elementAt(index)['tempo'], style: TextStyle(color: Colors.black),),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.17,
                                      child: Text(dados.elementAt(index)['bird']),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.17,
                                      child: Text(dados.elementAt(index)['die']),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.17,
                                      child: Text(dados.elementAt(index)['estoque']),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.15,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(()  {
                                            _popDao.deleteDadoFB('$url$keyPop/dados', dados.elementAt(index)['key']);
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
