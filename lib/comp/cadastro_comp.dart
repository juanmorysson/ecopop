import 'dart:ffi';

import 'package:eco_pop/comp/comp.dart';
import 'package:eco_pop/comp/comp_dao.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FormularioComp extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  State<StatefulWidget> createState() {
    return FormularioCompState();
  }
}

class FormularioCompState extends State<FormularioComp> {
  final TextEditingController _descricao_c = TextEditingController();
  final TextEditingController _fonte_c = TextEditingController();
  final TextEditingController _especie_a_c = TextEditingController();
  final TextEditingController _especie_b_c = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final CompDao _compDao = CompDao();

  @override
  Widget build(BuildContext context) {
    List<Object> args =
    ModalRoute.of(context)?.settings.arguments as List<Object>;
    final Comp? comp = args[0] as Comp?;
    final String? url = args[1] as String;
    if (comp!.key != "-0") {
      _descricao_c.text = comp.descricao;
      _especie_a_c.text = comp.especie_a;
      _especie_b_c.text = comp.especie_b;
      _fonte_c.text = comp.fonte.toString();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Projeto Competição / Predação'),
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
            TextField(
              controller: _especie_a_c,
              decoration: InputDecoration(
                labelText: 'Espécie A',
                hintText: '',
              ),
            ),
            TextField(
              controller: _especie_b_c,
              decoration: InputDecoration(
                labelText: 'Espécie B',
                hintText: '',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (comp.key != "-0") {
                      final Comp compCD = Comp(
                          0,
                          _descricao_c.text,
                          _especie_a_c.text,
                          _especie_b_c.text,
                          comp.key,
                          padrao: false,
                          fonte: _fonte_c.text,
                          );
                      //update
                      _compDao
                          .updateFB(compCD, url!)
                          .then((id) => Navigator.pop(context));
                    } else {
                      final Comp newComp = Comp(
                        0,
                        _descricao_c.text,
                        _especie_a_c.text,
                        _especie_b_c.text,
                        "-0",
                        padrao: false,
                        fonte: _fonte_c.text,
                      );
                      //Salvar
                      _compDao
                          .saveFB(newComp, url!)
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
