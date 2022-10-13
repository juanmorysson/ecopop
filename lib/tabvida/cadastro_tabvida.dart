import 'dart:ffi';

import 'package:eco_pop/tabvida/tabvida.dart';
import 'package:eco_pop/tabvida/tabvida_dao.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FormularioTabVida extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  State<StatefulWidget> createState() {
    return FormularioTabVidaState();
  }
}

class FormularioTabVidaState extends State<FormularioTabVida> {
  final TextEditingController _descricao_c = TextEditingController();
  final TextEditingController _fonte_c = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TabVidaDao _tabVidaDao = TabVidaDao();

  @override
  Widget build(BuildContext context) {
    List<Object> args =
    ModalRoute.of(context)?.settings.arguments as List<Object>;
    final TabVida? tabVida = args[0] as TabVida?;
    final String? url = args[1] as String;
    if (tabVida!.key != "-0") {
      _descricao_c.text = tabVida.descricao;
      _fonte_c.text = tabVida.fonte.toString();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Projeto Tabela de Vida'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 20.0),
        child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextField(
              controller: _descricao_c,
              decoration: InputDecoration(
                labelText: 'Descrição',
                hintText: '',
              ),
            ),
            TextField(
              controller: _fonte_c,
              decoration: InputDecoration(
                labelText: 'Fonte',
                hintText: 'http://',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (tabVida.key != "-0") {
                      final TabVida tabVidaCD = TabVida(
                          0,
                          _descricao_c.text,
                          tabVida.key,
                          padrao: false,
                          fonte: _fonte_c.text,
                          );
                      //update
                      _tabVidaDao
                          .updateFB(tabVidaCD, url!)
                          .then((id) => Navigator.pop(context));
                    } else {
                      final TabVida newTabVida = TabVida(
                        0,
                        _descricao_c.text,
                        "-0",
                        padrao: false,
                        fonte: _fonte_c.text,
                      );
                      //Salvar
                      _tabVidaDao
                          .saveFB(newTabVida, url!)
                          .then((id) => Navigator.pop(context));
                    }
                  }
                },
                child: Text('Confirmar'),
              ),
            ),
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
