import 'package:eco_pop/tabvida/tabvida.dart';
import 'package:eco_pop/tabvida/tabvida_dao.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class VerTabVida extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VerTabVidaState();
  }
}

class VerTabVidaState extends State<VerTabVida> {
  final TextEditingController _tempo_c = TextEditingController();
  final TabVidaDao _tabvidaDao = TabVidaDao();
  late final List<Map<String, dynamic>> snapshot;
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
    final TabVida? tabvida = args[0] as TabVida?;
    final String? url = args[1] as String;
    var keyTabVida = tabvida!.key.toString();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Proj TabVidaulação'),
      ),
      body:  FutureBuilder<List<Map<String, dynamic>>>(
                      future: _tabvidaDao.findClassesFB('$url$keyTabVida/classes'),
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
                            final List<Map<String, dynamic>> dadosTabVida = snapshot.data!;
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
                                                     title: Text(tabvida!=null?tabvida.descricao:""),
                                                     subtitle: Text(tabvida!=null?tabvida.fonte.toString():"")
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
                                                   itemCount: dadosTabVida.length,
                                                   itemBuilder: (BuildContext ctxt, int index) {
                                                     return new Card(
                                                       child: Row(
                                                         mainAxisAlignment: MainAxisAlignment.center,
                                                         children: [
                                                           SizedBox(
                                                             width: MediaQuery.of(context).size.width*0.20,
                                                             child: Text(dadosTabVida.elementAt(index)['tempo']),
                                                           ),
                                                           SizedBox(
                                                             width: MediaQuery.of(context).size.width*0.20,
                                                             child: Text(dadosTabVida.elementAt(index)['bird']),
                                                           ),
                                                           SizedBox(
                                                             width: MediaQuery.of(context).size.width*0.20,
                                                             child: Text(dadosTabVida.elementAt(index)['die']),
                                                           ),
                                                           SizedBox(
                                                             width: MediaQuery.of(context).size.width*0.20,
                                                             child: Text(dadosTabVida.elementAt(index)['estoque']),
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
                                                     //subtitle: Text(tabvida!=null?tabvida.experimento!=null?tabvida.experimento:""):""),
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
                                                             _dataPointsBird(dadosTabVida),
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
                                                     //subtitle: Text(tabvida!=null?tabvida.experimento!=null?tabvida.experimento:""):""),
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
                                                             _dataPointsDie(dadosTabVida),
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
                                                     //subtitle: Text(tabvida!=null?tabvida.experimento!=null?tabvida.experimento:""):""),
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
                                                             _dataPointsEstoque(dadosTabVida),
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
