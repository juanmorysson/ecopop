import 'package:eco_pop/utils/teste_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Info extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InfoState();
  }
}

class InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Projeto eCoPoP'),
      ),
      body: MaterialApp(
        home: ListView(
           children: [
             Container(
               alignment: Alignment.center,
               width: MediaQuery.of(context).size.height*0.16,
               height: MediaQuery.of(context).size.height*0.16,
               decoration: const BoxDecoration(
                 shape: BoxShape.rectangle,
                 image: DecorationImage(
                   alignment: Alignment.center,
                   image: AssetImage('assets/ecopop.png'),
                 ), //AssetImage("assets/Serenity.png"),
               ),
             ),
             Card(
               child: ListTile(
                 subtitle: Text("O projeto eCoPoP é fruto de trabalho conjunto dos:"),
               ),
             ),
             Card(
               child: ListTile(
                 title: Text("Instituto Federal do Piauí - IFPI | Campus Corrente"),
                 subtitle: Text("através do projeto de Extensão 'Informatização do Ensino de "
                     "Ecologia das Populações em Cursos de áreas Biológicas', executado pelo Edital"
                     " PROIC INICIAÇÃO 2021 – PROEX/IFPI da Pró-Reitoria de Extensão"),
               ),
             ),
             Card(
               child: ListTile(
                 title: Text("Instituto Federal Goiano - IFGoiano | Campus Urutaí "),
                 subtitle: Text("através do Programa de Pós-Graduação em Conservação de "
                     "Recursos Naturais do Cerrado (CRENAC) ligado a Diretoria "
                     "de Pesquisa e Pós-Graduação"),
               ),
             ),
             SizedBox(
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   SizedBox(
                     width: MediaQuery.of(context).size.width*0.45,
                     child: Container(
                       alignment: Alignment.center,
                       width: MediaQuery.of(context).size.width*0.45,
                       height: MediaQuery.of(context).size.width*0.45,
                       decoration: const BoxDecoration(
                         shape: BoxShape.rectangle,
                         image: DecorationImage(
                           alignment: Alignment.center,
                           image: AssetImage('assets/logo_corrente.png'),
                         ), //AssetImage("assets/Serenity.png"),
                       ),
                     ),
                   ),
                   SizedBox(
                     width: MediaQuery.of(context).size.width*0.45,
                     child: Container(
                       alignment: Alignment.center,
                       width: MediaQuery.of(context).size.width*0.45,
                       height: MediaQuery.of(context).size.width*0.45,
                       decoration: const BoxDecoration(
                         shape: BoxShape.rectangle,
                         image: DecorationImage(
                           alignment: Alignment.center,
                           image: AssetImage('assets/logo_urutai.png'),
                         ), //AssetImage("assets/Serenity.png"),
                       ),
                     ),
                   ),
                 ],
               ),
             ),
             Card(
               child: ListTile(
                 subtitle: Text("Desenvolvedores:"),
               ),
             ),
             Card(
               child: ListTile(
                 title: Text("Dr. Daniel de Paiva Silva"),
                 subtitle: Text("Professor IFGoiano"),
               ),
             ),
             Card(
               child: ListTile(
                 title: Text("Mestrando Juan Morysson Viana Marciano"),
                 subtitle: Text("Professor IFPI e Aluno IFGoiano"),
                 onTap: () {
                 Navigator.of(context)
                   .push(
                     MaterialPageRoute(
                       builder: (context) =>
                         //Splash(),
                         //Info(),
                         MyHomePage(title: "teste"),
                         settings:
                         RouteSettings(arguments: null),
                       ),
                   ).then(
                     (value) => setState(() {}),
                   );
                 },
               ),
             ),
             Card(
               child: ListTile(
                 title: Text("Msc Marcilia Martins da Silva"),
                 subtitle: Text("Professora IFPI"),
               ),
             ),
             Card(
               child: ListTile(
                 title: Text("Oberis dos Santos Nascimento"),
                 subtitle: Text("Aluno IFPI"),
               ),
             ),
             Card(
               child: ListTile(
                 title: Text("Karine Nunes Ribeiro Dos Santos"),
                 subtitle: Text("Aluna IFPI"),
               ),
             ),
           ]
       ),
      )
    );
  }
}
