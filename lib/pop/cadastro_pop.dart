import 'dart:ffi';

import 'package:eco_pop/pop/pop.dart';
import 'package:eco_pop/pop/pop_dao.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FormularioPop extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  State<StatefulWidget> createState() {
    return FormularioPopState();
  }
}

class FormularioPopState extends State<FormularioPop> {
  final TextEditingController _conceito_c = TextEditingController();
  final TextEditingController _descricao_c = TextEditingController();
  final TextEditingController _experimento_c = TextEditingController();
  final TextEditingController _fonte_c = TextEditingController();
  final TextEditingController _formula_c = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final PopDao _popDao = PopDao();

  @override
  Widget build(BuildContext context) {
    List<Object> args =
    ModalRoute.of(context)?.settings.arguments as List<Object>;
    final Pop? pop = args[0] as Pop?;
    final String? url = args[1] as String;
    if (pop!.key != "-0") {
      _conceito_c.text = pop.conceito.toString();
      _descricao_c.text = pop.descricao;
      _experimento_c.text = pop.experimento.toString();
      _fonte_c.text = pop.fonte.toString();
      _formula_c.text = pop.formula.toString();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Projeto Pop'),
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
              controller: _experimento_c,
              decoration: InputDecoration(
                labelText: 'Experimento',
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
              controller: _conceito_c,
              decoration: InputDecoration(
                labelText: 'Conceito',
                hintText: '',
              ),
            ),
            TextField(
              controller: _formula_c,
              decoration: InputDecoration(
                labelText: 'Fórmula',
                hintText: '',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (pop.key != "-0") {
                      final Pop popCD = Pop(
                          0,
                          _descricao_c.text,
                          pop.key,
                          padrao: false,
                          formula: _formula_c.text,
                          fonte: _fonte_c.text,
                          experimento: _experimento_c.text,
                          conceito: _conceito_c.text
                          );
                      //update
                      _popDao
                          .updateFB(popCD, url!)
                          .then((id) => Navigator.pop(context));
                    } else {
                      final Pop newPop = Pop(
                        0,
                        _descricao_c.text,
                        "-0",
                        padrao: false,
                        formula: _formula_c.text,
                        fonte: _fonte_c.text,
                        experimento: _experimento_c.text,
                        conceito: _conceito_c.text
                      );
                      //Salvar
                      _popDao
                          .saveFB(newPop, url!)
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
