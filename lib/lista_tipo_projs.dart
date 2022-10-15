import 'package:eco_pop/comp/lista_comp.dart';
import 'package:eco_pop/pop/lista_pop.dart';
import 'package:eco_pop/tabvida/lista_tabvida.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ListarTipoProjs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListarTipoProjsState();
  }
}

class ListarTipoProjsState extends State<ListarTipoProjs> {
  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount? user =
        ModalRoute.of(context)?.settings.arguments as GoogleSignInAccount?;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Tipo de Projeto'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.8,
              height: MediaQuery
                  .of(context)
                  .size
                  .width * 0.15,
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
                backgroundColor: Colors.lightGreen[900],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.workspaces_filled, size: MediaQuery
                        .of(context)
                        .size
                        .width * 0.09),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Pop", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),),
                        Text("Crescimento Populacional", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03),),
                      ],
                    )
                  ],
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.8,
              height: MediaQuery
                  .of(context)
                  .size
                  .width * 0.15,
              child: FloatingActionButton(
                onPressed:() {
                  final Future future =
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListarTabVida(),
                    settings: RouteSettings(arguments: user),
                  ));
                  future.then((grupo) {
                    //teste
                  });
                },
                backgroundColor: Colors.lightGreen,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.view_list, size: MediaQuery
                        .of(context)
                        .size
                        .width * 0.09),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("TabVida", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),),
                        Text("Tabela de Vida", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03),),
                      ],
                    )
                  ],
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.8,
              height: MediaQuery
                  .of(context)
                  .size
                  .width * 0.15,
              child: FloatingActionButton(
                onPressed:() {
                  final Future future =
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListarComp(),
                    settings: RouteSettings(arguments: user),
                  ));
                  future.then((grupo) {
                    //teste
                  });
                },
                backgroundColor: Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.zoom_out_map_sharp, size: MediaQuery
                        .of(context)
                        .size
                        .width * 0.09),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("CompPred", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),),
                        Text("Competição ou Predação", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03),),
                      ],
                    )
                  ],
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
