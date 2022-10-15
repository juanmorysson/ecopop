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
  List<Map<String, dynamic>> dadosTabVida =[];

  final Color dark = const Color(0xff3b8c75);
  final Color normal = const Color(0xff64caad);
  final Color light = const Color(0xff73e8c9);

  @override
  void initState() {
    super.initState();
    // create a data model
  }

  List<BarChartGroupData> getData(List<Map<String, dynamic>> dados) {
    List<BarChartGroupData> list = [];
    var i = 0;
    var tX = 0.80/dados.length;
    while (i < dados.length) {
      var s = double.parse(dados.elementAt(i)['sobreviventes']);
      list.add(
        BarChartGroupData(
          x: i,
          barsSpace: 5,
          barRods: [
            BarChartRodData(
                width: MediaQuery.of(context).size.width * tX,
                toY: s,
                rodStackItems: [
                  BarChartRodStackItem(0, s, dark),
                ],
                borderRadius: const BorderRadius.all(Radius.zero)),
          ],
        ),
      );
      i = i + 1;
    }
    return list;
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Color(0xff939393),fontSize: 10,);
    return SideTitleWidget(
      child: Text(value.toString(), style: style),
      axisSide: meta.axisSide,
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Color(0xff939393), fontSize: 10, );
    var i = value.toInt();
    var text = dadosTabVida.elementAt(i)['idade_inicio']+" a "+dadosTabVida.elementAt(i)['idade_fim'];
    return SideTitleWidget(
      child: Text(text, style: style),
      axisSide: meta.axisSide,
    );
  }

  Widget bottomTitlesCurve(double value, TitleMeta meta) {
    const style = TextStyle(color: Color(0xff939393), fontSize: 10, );
    print("XXXXXXXXXXXXXXXXXXx");
    print(dadosTabVida.length);
    var i = value.toInt();
    var text = dadosTabVida.elementAt(i)['idade_inicio'];
    return SideTitleWidget(
      child: Text(text, style: style),
      axisSide: meta.axisSide,
    );
  }

  List<FlSpot> _dataPoints(List<Map<String, dynamic>> dados) {
    List<FlSpot> dataPoints = [];
    var i=0;
    while ( i < dados.length ){
      var s = double.parse(dados.elementAt(i)['sobreviventes']);
      var ini = double.parse(dados.elementAt(i)['idade_inicio']);
      dataPoints.add(FlSpot(ini, s));
      i = i +1;
      print(ini.toString()+"---"+ s.toString());
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
    final TabVida? tabvida = args[0] as TabVida?;
    final String? url = args[1] as String;
    var keyTabVida = tabvida!.key.toString();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Proj Tabela de Vida'),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
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
                dadosTabVida = snapshot.data!;
                return
                  MaterialApp(
                      home: DefaultTabController(
                        length: 2,
                        initialIndex: _tab,
                        child: Scaffold(
                            appBar: TabBar(
                              tabs: [
                                Tab(text: "Dados",),
                                Tab(text: "Gráficos",)
                              ],
                              labelColor: Colors.green,
                              indicatorColor: Colors.orange[300],
                            ),
                            body: TabBarView(
                                children: [
                            //Dados
                            Container(
                            child: ListView(
                            children: [
                                Card(
                                child: ListTile(
                                  title: Text(tabvida!=null?tabvida.descricao:""),
                                  subtitle: Text(
                                  tabvida != null ? tabvida.fonte.toString() : "")
                                ),
                              ),
                              Card(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.25,
                                      child: Text("Classe"),
                                    ),
                                    SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.15,
                                      child: Text("N"),
                                    ),
                                    SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.14,
                                      child: Text("I"),
                                    ),
                                    SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.14,
                                      child: Text("q"),
                                    ),
                                    SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.15,
                                      child: Text("d"),
                                    ),
                                    SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.15,
                                      child: Text("p"),
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
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.25,
                                            child: Text("De " + dadosTabVida.elementAt(
                                                index)['idade_inicio'] + " até " +
                                                dadosTabVida.elementAt(
                                                    index)['idade_fim']),
                                          ),
                                          SizedBox(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.15,
                                            child: Text(dadosTabVida.elementAt(
                                                index)['sobreviventes']),
                                          ),
                                          SizedBox(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.14,
                                            child: Text(
                                                dadosTabVida.elementAt(index)['I']),
                                          ),
                                          SizedBox(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.14,
                                            child: Text(
                                                dadosTabVida.elementAt(index)['d']),
                                          ),
                                          SizedBox(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.15,
                                            child: Text(
                                                dadosTabVida.elementAt(index)['q']),
                                          ),
                                          SizedBox(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.15,
                                            child: Text(
                                                dadosTabVida.elementAt(index)['p']),
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
                                  title: Text("Gráfico Etário"),
                                  //subtitle: Text(tabvida!=null?tabvida.experimento!=null?tabvida.experimento:""):""),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.02),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width*0.9,
                                  height: MediaQuery.of(context).size.height*0.3,
                                  //padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
                                  child: BarChart(
                                    BarChartData(
                                      alignment: BarChartAlignment.center,
                                      barTouchData: BarTouchData(
                                        enabled: false,
                                      ),
                                      titlesData: FlTitlesData(
                                        show: true,
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: MediaQuery.of(context).size.width * 0.10,
                                            getTitlesWidget: bottomTitles,
                                          ),
                                        ),
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: MediaQuery.of(context).size.width * 0.10,
                                            getTitlesWidget: leftTitles,
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
                                        checkToShowHorizontalLine: (value) => value % 10 == 0,
                                        getDrawingHorizontalLine: (value) => FlLine(
                                          color: const Color(0xffe7e8ec),
                                          strokeWidth: 1,
                                        ),
                                        drawVerticalLine: false,
                                      ),
                                      borderData: FlBorderData(
                                        show: false,
                                      ),
                                      groupsSpace: 6,
                                      barGroups: getData(dadosTabVida),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  title: Text("Curva de Sobrevivência"),
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
                                            spots: _dataPoints(dadosTabVida),
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
