import 'package:eco_pop/pop/pop.dart';
import 'package:eco_pop/pop/pop_dao.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class VerPop extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VerPopState();
  }
}

class VerPopState extends State<VerPop> {
  final TextEditingController _tempo_c = TextEditingController();
  final PopDao _popDao = PopDao();
  late final List<Map<String, dynamic>> snapshot;
  var t_inicio = 0.0;
  var e_inicio = 0.0;
  var tempo = 0.0;
  var predicao = 0.0;
  var t_dif = 0.0;
  var r = 0.0;
  var _tab = 0;

  @override
  void initState() {
    super.initState();
    // create a data model
  }

  List<FlSpot> _dataPointsEstoque(List<Map<String, dynamic>> dados) {
    List<FlSpot> dataPoints = [];
    var i=0;
    while ( i < dados.length ){
      var t = dados.elementAt(i)['tempo'];
      var e = dados.elementAt(i)['estoque'];
      dataPoints.add(FlSpot(double.parse(t),double.parse(e)));
      i = i +1;
    }
    return dataPoints;
  }

  List<FlSpot> _dataPointsBird(List<Map<String, dynamic>> dados) {
    List<FlSpot> dataPoints = [];
    var i=0;
    while ( i < dados.length ){
      var t = dados.elementAt(i)['tempo'];
      var e = dados.elementAt(i)['bird'];
      dataPoints.add(FlSpot(double.parse(t),double.parse(e)));
      i = i +1;
    }
    return dataPoints;
  }

  List<FlSpot> _dataPointsDie(List<Map<String, dynamic>> dados) {
    List<FlSpot> dataPoints = [];
    var i=0;
    while ( i < dados.length ){
      var t = dados.elementAt(i)['tempo'];
      var e = dados.elementAt(i)['die'];
      dataPoints.add(FlSpot(double.parse(t),double.parse(e)));
      i = i +1;
    }
    return dataPoints;
  }

  List<FlSpot> _dataPointsPredicao(List<Map<String, dynamic>> dados) {
    List<FlSpot> dataPoints = [];
    t_inicio = double.parse(dados.elementAt(0)['tempo']);
    e_inicio = double.parse(dados.elementAt(0)['estoque']);
    var t_final = double.parse(dados.elementAt(dados.length-1)['tempo']);
    var e_final = double.parse(dados.elementAt(dados.length-1)['estoque']);
    r = (e_final-e_inicio)/(t_final - t_inicio);
    var i=0;
    t_dif = t_final - t_inicio;
    while ( i < 4 ){
      var t = (t_dif/3)*i + double.parse(dados.elementAt(0)['tempo']);
      var e = (r*(t-t_inicio)*(t-t_inicio))/t_dif + e_inicio;
      if (i==0){
        if(tempo == t) {
          tempo = t;
          predicao = e;
        }
      }
      dataPoints.add(FlSpot(t, e));
      i = i +1;
      print("Tempo: "+t.toString() + "e: "+e.toString());
    }
    return dataPoints;
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10, );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(value.toString(),
          style: style,
        ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10, );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: RotatedBox(
        quarterTurns: -1,
        child: Text(value.toString(),
          style: style,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Object> args =
    ModalRoute.of(context)?.settings.arguments as List<Object>;
    final Pop? pop = args[0] as Pop?;
    final String? url = args[1] as String;
    var keyPop = pop!.key.toString();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Proj População'),
      ),
      body:  FutureBuilder<List<Map<String, dynamic>>>(
                      future: _popDao.findDadosFB('$url$keyPop/dados'),
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
                                 length: 4,
                                 initialIndex: _tab,
                                 child: Scaffold(
                                   appBar: TabBar(
                                     tabs: [Tab(text: "Dados",), Tab(text: "Gráficos",), Tab(text: "Estoque",), Tab(text: "Predição",)],
                                     labelColor: Colors.green,
                                     indicatorColor: Colors.orange[300],
                                   ),
                                   body:TabBarView(
                                       children: [
                                         //Dados
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
                                         ),
                                         //Gráfico Nascimentos de Mortes
                                         ListView(
                                             children: [
                                               Card(
                                                   child: ListTile(
                                                     title: Text("Gráfico evolutivo de Nascimentos"),
                                                     //subtitle: Text(pop!=null?pop.experimento!=null?pop.experimento:""):""),
                                                   ),
                                               ),
                                               Padding(
                                                 padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.02),
                                                 child: SizedBox(
                                                   width: MediaQuery.of(context).size.width*0.9,
                                                   height: MediaQuery.of(context).size.height*0.3,
                                                   //padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
                                                   child: LineChart(
                                                       LineChartData(
                                                         lineTouchData: LineTouchData(enabled: false),
                                                         lineBarsData: [
                                                           LineChartBarData(
                                                             spots: //const [FlSpot(0, 100), FlSpot(100, 200)],
                                                             _dataPointsBird(dadosPop),
                                                             isCurved: false,
                                                             barWidth: 2,
                                                             color: Colors.blue,
                                                             dotData: FlDotData(
                                                               show: true,
                                                             ),
                                                           )
                                                         ],
                                                         //minY: 0,
                                                         titlesData: FlTitlesData(
                                                           bottomTitles: AxisTitles(
                                                             sideTitles: SideTitles(
                                                                 showTitles: true,
                                                                 //interval: _interval_birds_x,
                                                                 getTitlesWidget: bottomTitleWidgets,
                                                                 reservedSize: 50
                                                             ),
                                                           ),
                                                           leftTitles: AxisTitles(
                                                             sideTitles: SideTitles(
                                                               showTitles: true,
                                                               getTitlesWidget: leftTitleWidgets,
                                                               //interval: _interval_birds_y,
                                                               reservedSize: 50,
                                                             ),
                                                           ),
                                                           topTitles: AxisTitles(
                                                             sideTitles: SideTitles(showTitles: false),
                                                           ),
                                                           rightTitles: AxisTitles(
                                                             sideTitles: SideTitles(showTitles: false),
                                                           ),
                                                         ),
                                                         gridData: FlGridData(
                                                           show: true,
                                                           drawVerticalLine: true,
                                                           horizontalInterval: 1,
                                                           checkToShowHorizontalLine: (double value) {
                                                             return value == 1 || value == 6 || value == 4 || value == 5;
                                                           },
                                                         ),
                                                       )
                                                   ),
                                                 ),
                                               ),
                                               Card(
                                                   child: ListTile(
                                                     title: Text("Gráfico evolutivo de mortes"),
                                                     //subtitle: Text(pop!=null?pop.experimento!=null?pop.experimento:""):""),
                                                   ),
                                               ),
                                               Padding(
                                                 padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.02),
                                                 child: SizedBox(
                                                   width: MediaQuery.of(context).size.width*0.9,
                                                   height: MediaQuery.of(context).size.height*0.3,
                                                   //padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
                                                   child: LineChart(
                                                       LineChartData(
                                                         lineTouchData: LineTouchData(enabled: false),
                                                         lineBarsData: [
                                                           LineChartBarData(
                                                             spots: //const [FlSpot(0, 100), FlSpot(100, 200)],
                                                             _dataPointsDie(dadosPop),
                                                             isCurved: false,
                                                             barWidth: 2,
                                                             color: Colors.red,
                                                             dotData: FlDotData(
                                                               show: true,
                                                             ),
                                                           )
                                                         ],
                                                         //minY: 0,
                                                         titlesData: FlTitlesData(
                                                           bottomTitles: AxisTitles(
                                                             sideTitles: SideTitles(
                                                                 showTitles: true,
                                                                 //interval: _interval_x,
                                                                 getTitlesWidget: bottomTitleWidgets,
                                                                 reservedSize: 90
                                                             ),
                                                           ),
                                                           leftTitles: AxisTitles(
                                                             sideTitles: SideTitles(
                                                               showTitles: true,
                                                               getTitlesWidget: leftTitleWidgets,
                                                               //interval: _interval_dies_y,
                                                               reservedSize: 40,
                                                             ),
                                                           ),
                                                           topTitles: AxisTitles(
                                                             sideTitles: SideTitles(showTitles: false),
                                                           ),
                                                           rightTitles: AxisTitles(
                                                             sideTitles: SideTitles(showTitles: false),
                                                           ),
                                                         ),
                                                         gridData: FlGridData(
                                                           show: true,
                                                           drawVerticalLine: true,
                                                           horizontalInterval: 1,
                                                           checkToShowHorizontalLine: (double value) {
                                                             return value == 1 || value == 6 || value == 4 || value == 5;
                                                           },
                                                         ),
                                                       )
                                                   ),
                                                 ),
                                               ),

                                             ]
                                         ),
                                         //Gráfico Estoque
                                         ListView(
                                             children: [
                                               Card(
                                                   child: ListTile(
                                                     title: Text("Gráfico de Estoque (tamanho da poupulação)"),
                                                     //subtitle: Text(pop!=null?pop.experimento!=null?pop.experimento:""):""),
                                                   ),
                                               ),
                                               Padding(
                                                 padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.02),
                                                 child: SizedBox(
                                                   width: MediaQuery.of(context).size.width*0.9,
                                                   height: MediaQuery.of(context).size.height*0.4,
                                                   //padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
                                                   child: LineChart(
                                                       LineChartData(
                                                         lineTouchData: LineTouchData(enabled: false),
                                                         lineBarsData: [
                                                           LineChartBarData(
                                                             spots: //const [FlSpot(0, 100), FlSpot(100, 200)],
                                                             _dataPointsEstoque(dadosPop),
                                                             isCurved: false,
                                                             barWidth: 2,
                                                             color: Colors.green,
                                                             dotData: FlDotData(
                                                               show: true,
                                                             ),
                                                           )
                                                         ],
                                                         //minY: 0,
                                                         titlesData: FlTitlesData(
                                                           bottomTitles: AxisTitles(
                                                             sideTitles: SideTitles(
                                                                 showTitles: true,
                                                                 //interval: _interval_x,
                                                                 getTitlesWidget: bottomTitleWidgets,
                                                                 reservedSize: 90
                                                             ),
                                                           ),
                                                           leftTitles: AxisTitles(
                                                             sideTitles: SideTitles(
                                                               showTitles: true,
                                                               getTitlesWidget: leftTitleWidgets,
                                                               //interval: _interval_estoque_y,
                                                               reservedSize: 40,
                                                             ),
                                                           ),
                                                           topTitles: AxisTitles(
                                                             sideTitles: SideTitles(showTitles: false),
                                                           ),
                                                           rightTitles: AxisTitles(
                                                             sideTitles: SideTitles(showTitles: false),
                                                           ),
                                                         ),
                                                         gridData: FlGridData(
                                                           show: true,
                                                           drawVerticalLine: true,
                                                           horizontalInterval: 1,
                                                           checkToShowHorizontalLine: (double value) {
                                                             return value == 1 || value == 6 || value == 4 || value == 5;
                                                           },
                                                         ),
                                                       )
                                                   ),
                                                 ),
                                               ),
                                             ]
                                         ),
                                         //Predição
                                         ListView(
                                             children: [
                                               Card(
                                                   child: ListTile(
                                                     title: Text("Gráfico Preditivo"),
                                                     //subtitle: Text(pop!=null?pop.experimento!=null?pop.experimento:""):""),
                                                   ),
                                               ),
                                               Padding(
                                                 padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.02),
                                                 child: SizedBox(
                                                   width: MediaQuery.of(context).size.width*0.9,
                                                   height: MediaQuery.of(context).size.height*0.3,
                                                   child: LineChart(
                                                       LineChartData(
                                                         lineTouchData: LineTouchData(enabled: false),
                                                         lineBarsData: [
                                                           LineChartBarData(
                                                             spots: _dataPointsPredicao(dadosPop),
                                                             isCurved: true,
                                                             barWidth: 2,
                                                             color: Colors.red,
                                                             dotData: FlDotData(
                                                               show: false,
                                                             ),
                                                           )
                                                         ],
                                                         //minY: 0,
                                                         titlesData: FlTitlesData(
                                                           bottomTitles: AxisTitles(
                                                             sideTitles: SideTitles(
                                                               showTitles: true,
                                                               reservedSize: 40,
                                                               //interval: 1,
                                                               getTitlesWidget: bottomTitleWidgets,
                                                             ),
                                                           ),
                                                           leftTitles: AxisTitles(
                                                             sideTitles: SideTitles(
                                                               showTitles: true,
                                                               getTitlesWidget: leftTitleWidgets,
                                                               //interval: 1,
                                                               reservedSize: 40,
                                                             ),
                                                           ),
                                                           topTitles: AxisTitles(
                                                             sideTitles: SideTitles(showTitles: false),
                                                           ),
                                                           rightTitles: AxisTitles(
                                                             sideTitles: SideTitles(showTitles: false),
                                                           ),
                                                         ),
                                                         gridData: FlGridData(
                                                           show: true,
                                                           drawVerticalLine: false,
                                                           horizontalInterval: 1,
                                                           checkToShowHorizontalLine: (double value) {
                                                             return value == 1 || value == 6 || value == 4 || value == 5;
                                                           },
                                                         ),
                                                       )
                                                   ),
                                                 ),
                                               ),

                                               Card(
                                                 child: ListTile(
                                                   title: Text("Predição para o tempo = "+tempo.toString()),
                                                   subtitle: Text(predicao.toString(),
                                                     style: TextStyle(
                                                         color: Colors.amber,
                                                         fontWeight: FontWeight.bold,
                                                         fontSize: 24.0
                                                     ),),
                                                 ),
                                               ),
                                               Column(
                                                     children: [
                                                       TextFormField(
                                                         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                         keyboardType: TextInputType.number,
                                                         controller: _tempo_c,
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
                                                             tempo = double.parse(_tempo_c.text);
                                                             _tab = 3;
                                                             var e = (r*(tempo-t_inicio)*(tempo-t_inicio))/t_dif + e_inicio;
                                                             setState(()  {
                                                              predicao = double.parse(e.toString());
                                                             });
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
