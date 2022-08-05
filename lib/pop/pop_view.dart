import 'dart:math';

import 'package:eco_pop/grupo-pesquisa/cadastro_grupo.dart';
import 'package:eco_pop/pop/pop.dart';
import 'package:eco_pop/pop/pop_dao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simple_line_chart/simple_line_chart.dart';

class VerPop extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VerPopState();
  }
}

class VerPopState extends State<VerPop> {
  final PopDao _popDao = PopDao();
  late final List<Map<String, dynamic>> snapshot;
  var tempo = 0.0;
  var predicao = 0.0;
  var t_dif = 0.0;
  var r = 0.0;

  @override
  void initState() {
    super.initState();
    // create a data model
  }

  LineChartData _createDataPoints(List<Map<String, dynamic>> dados) {
    List<DataPoint> dataPoints = [];
    var i=0;
    while ( i < dados.length ){
      var t = dados.elementAt(i)['tempo'];
      var e = dados.elementAt(i)['estoque'];
      dataPoints.add(DataPoint(x: double.parse(t), y: double.parse(e)));
      i = i +1;
    }
    late LineChartData? data = LineChartData(datasets: [
      Dataset(
      label: 'População',
      dataPoints: dataPoints
      ),
    ]);
    return data;
  }

  LineChartData _createDataPointsPredicao(List<Map<String, dynamic>> dados) {
    List<DataPoint> dataPoints = [];
    var t_inicio = double.parse(dados.elementAt(0)['tempo']);
    var e_inicio = double.parse(dados.elementAt(0)['estoque']);
    var t_final = double.parse(dados.elementAt(dados.length-1)['tempo']);
    var e_final = double.parse(dados.elementAt(dados.length-1)['estoque']);
    r = (e_final-e_inicio)/(t_final - t_inicio);
    var i=0;
    t_dif = t_final - t_inicio;
    while ( i < 4 ){
      var t = (t_dif/3)*i + double.parse(dados.elementAt(0)['tempo']);
      var e = (r*t*t)/t_dif;
      if (i==0){
        tempo = t;
        predicao = e;
      }
      dataPoints.add(DataPoint(x: t, y: e));
      i = i +1;
    }
    late LineChartData? data = LineChartData(datasets: [
      Dataset(
          label: 'Crescimento exponencial \n calculado por r = '+ r.toString(),
          dataPoints: dataPoints
      ),
    ]);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final Pop? pop =
    ModalRoute.of(context)?.settings.arguments as Pop?;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Proj População'),
      ),
      body:  FutureBuilder<List<Map<String, dynamic>>>(
                      future: _popDao.findDadosFB('projetos_padrao/'+pop!.key+'/dados'),
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
                            final List<Map<String, dynamic>> dadosPop = snapshot.data!;
                            return
                              MaterialApp(
                               home: DefaultTabController(
                                 length: 3,
                                 child: Scaffold(
                                   appBar: TabBar(
                                     tabs: [Tab(text: "Dados",), Tab(text: "Gráfico",), Tab(text: "Predição",)],
                                     labelColor: Colors.green,
                                     indicatorColor: Colors.orange[300],
                                   ),
                                   body:TabBarView(
                                       children: [
                                         Container(
                                           child: ListView(
                                               children: [
                                                 Card(
                                                   child: ListTile(
                                                     title: Text(pop!=null?pop.descricao:""),
                                                     subtitle: Text(pop!=null?pop.experimento.toString():"")
                                                   ),
                                                 ),
                                                 Card(
                                                   child: Row(
                                                     mainAxisAlignment: MainAxisAlignment.center,
                                                     children: [
                                                       SizedBox(
                                                         width: MediaQuery.of(context).size.width*0.20,
                                                         child: Text("Tempo"),
                                                       ),
                                                       SizedBox(
                                                         width: MediaQuery.of(context).size.width*0.20,
                                                         child: Text("Nacimentos"),
                                                       ),
                                                       SizedBox(
                                                         width: MediaQuery.of(context).size.width*0.20,
                                                         child: Text("Mortes"),
                                                       ),
                                                       SizedBox(
                                                         width: MediaQuery.of(context).size.width*0.20,
                                                         child: Text("Estoque"),
                                                       ),
                                                     ],
                                                   ),
                                                 ),
                                                 ListView.builder(
                                                   shrinkWrap: true,
                                                   itemCount: dadosPop.length,
                                                   itemBuilder: (BuildContext ctxt, int index) {
                                                     return new Card(
                                                       child: Row(
                                                         mainAxisAlignment: MainAxisAlignment.center,
                                                         children: [
                                                           SizedBox(
                                                             width: MediaQuery.of(context).size.width*0.20,
                                                             child: Text(dadosPop.elementAt(index)['tempo']),
                                                           ),
                                                           SizedBox(
                                                             width: MediaQuery.of(context).size.width*0.20,
                                                             child: Text(dadosPop.elementAt(index)['bird']),
                                                           ),
                                                           SizedBox(
                                                             width: MediaQuery.of(context).size.width*0.20,
                                                             child: Text(dadosPop.elementAt(index)['die']),
                                                           ),
                                                           SizedBox(
                                                             width: MediaQuery.of(context).size.width*0.20,
                                                             child: Text(dadosPop.elementAt(index)['estoque']),
                                                           ),
                                                         ],
                                                       ),
                                                     );
                                                   }
                                                 ),
                                               ]
                                           ),
                                         )
                                         ,
                                         Column(
                                             children: [
                                               MaterialButton(
                                                 onPressed: () {},
                                                 child: Card(
                                                   child: ListTile(
                                                     title: Text(pop!=null?pop.descricao:""),
                                                     //subtitle: Text(pop!=null?pop.experimento!=null?pop.experimento:""):""),
                                                   ),
                                                 ),
                                               ),
                                               Padding(
                                                 padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
                                                 child: LineChart(
                                                     style: LineChartStyle.fromTheme(context),
                                                     seriesHeight: 300,
                                                     data: _createDataPoints(dadosPop)
                                                 ),
                                               )
                                             ]
                                         ),
                                         Column(
                                             children: [
                                               Card(
                                                   child: ListTile(
                                                     title: Text("Gráfico Preditivo"),
                                                     //subtitle: Text(pop!=null?pop.experimento!=null?pop.experimento:""):""),
                                                   ),
                                               ),
                                               Padding(
                                                 padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
                                                 child: LineChart(
                                                     style: LineChartStyle.fromTheme(context),
                                                     seriesHeight: 300,
                                                     data: _createDataPointsPredicao(dadosPop)
                                                 ),
                                               ),
                                               Card(
                                                 child: ListTile(
                                                   title: Text("Prdição para o tempo = "+tempo.toString()),
                                                   subtitle: Text(predicao.toString()),
                                                 ),
                                               ),
                                               Column(
                                                     children: [
                                                       TextFormField(
                                                         controller: null,
                                                         style: TextStyle(
                                                           fontSize: 20.0,
                                                         ),
                                                         decoration: InputDecoration(
                                                           hintText: 'Tempo *',
                                                           //labelText: 'Descrição do grupo',
                                                           contentPadding: const EdgeInsets.all(8.0),
                                                         ),
                                                       ),
                                                       Padding(
                                                         padding: const EdgeInsets.all(8.0),
                                                         child: ElevatedButton(
                                                           onPressed: () {
                                                             var e = (r*113*113)/t_dif;
                                                             print(e);
                                                           },
                                                           child: Text('Preditar'),
                                                         ),
                                                       ),
                                                     ],
                                               ),
                                             ]
                                         ),


                                       ],

                                   )
                                 ),
                               ),
                              );
                            }
                            return Text('Unknown error');
                         }
                         ,
                    )

    );
  }
}
