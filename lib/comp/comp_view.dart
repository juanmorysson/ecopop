import 'package:eco_pop/comp/comp.dart';
import 'package:eco_pop/comp/comp_dao.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class VerComp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VerCompState();
  }
}

class VerCompState extends State<VerComp> {
  final TextEditingController _tempo_c = TextEditingController();
  final CompDao _compDao = CompDao();
  late final List<Map<String, dynamic>> snapshot;
  var _comp = 0;
  List<Map<String, dynamic>> dadosComp =[];

  final Color dark = const Color(0xff3b8c75);
  final Color normal = const Color(0xff64caad);
  final Color light = const Color(0xff73e8c9);

  @override
  void initState() {
    super.initState();
    // create a data model
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Color(0xff939393),fontSize: 10,);
    return SideTitleWidget(
      child: Text(value.toString(), style: style),
      axisSide: meta.axisSide,
    );
  }

  Widget bottomTitlesCurve(double value, TitleMeta meta) {
    const style = TextStyle(color: Color(0xff939393), fontSize: 10, );
    print(dadosComp.length);
    var i = value.toInt();
    var text = dadosComp.elementAt(i)['tempo'];
    return SideTitleWidget(
      child: Text(text, style: style),
      axisSide: meta.axisSide,
    );
  }

  List<FlSpot> _dataPointsA(List<Map<String, dynamic>> dados) {
    List<FlSpot> dataPoints = [];
    var i=0;
    while ( i < dados.length ){
      var q = double.parse(dados.elementAt(i)['qtd_especie_a']);
      var t = double.parse(dados.elementAt(i)['tempo']);
      dataPoints.add(FlSpot(t, q));
      i = i +1;
    }
    return dataPoints;
  }

  List<FlSpot> _dataPointsB(List<Map<String, dynamic>> dados) {
    List<FlSpot> dataPoints = [];
    var i=0;
    while ( i < dados.length ){
      var q = double.parse(dados.elementAt(i)['qtd_especie_b']);
      var t = double.parse(dados.elementAt(i)['tempo']);
      dataPoints.add(FlSpot(t, q));
      i = i +1;
    }
    return dataPoints;
  }

  @override
  Widget build(BuildContext context) {
    List<Object> args =
    ModalRoute
        .of(context)
        ?.settings
        .arguments as List<Object>;
    final Comp? comp = args[0] as Comp?;
    final String? url = args[1] as String;
    var keyComp = comp!.key.toString();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Proj Competição / Prdedação'),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _compDao.findDadosFB('$url$keyComp/dados'),
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
                dadosComp = snapshot.data!;
                return
                  MaterialApp(
                      home: DefaultTabController(
                        length: 1,
                        initialIndex: _comp,
                        child: Scaffold(
                            appBar: TabBar(
                              tabs: [
                                Tab(text: "Gráficos",)
                              ],
                              labelColor: Colors.green,
                              indicatorColor: Colors.orange[300],
                            ),
                            body: TabBarView(
                                children: [
                    //Gráficossssssssssss
                          ListView(
                            children: [
                              Card(
                                child: ListTile(
                                  title: Text("Gráfico Evolutivo"),
                                  //subtitle: Text(comp!=null?comp.experimento!=null?comp.experimento:""):""),
                                ),
                              ),
                              Card(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.40,
                                      child: Text(comp.especie_a.toString(), style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold ),),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.40,
                                      child: Text(comp.especie_b.toString(), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold ),),
                                    ),
                                  ],
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
                                            spots: _dataPointsA(dadosComp),
                                            isCurved: true,
                                            barWidth: 2,
                                            color: Colors.blue,
                                            dotData: FlDotData(
                                              show: false,
                                            ),
                                          ),
                                          LineChartBarData(
                                            spots: _dataPointsB(dadosComp),
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
                                              reservedSize: MediaQuery.of(context).size.width * 0.10,
                                              //interval: 1,
                                              //getTitlesWidget: bottomTitlesCurve,
                                            ),
                                          ),
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              getTitlesWidget: leftTitles,
                                              //interval: 1,
                                              reservedSize: MediaQuery.of(context).size.width * 0.10,
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
                                            return value == 1;
                                          },
                                        ),
                                      )
                                  ),
                                ),
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
