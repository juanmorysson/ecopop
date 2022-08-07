import 'dart:ffi';

class Pop {
  final int id;
  final String descricao;
  final String? conceito;
  final String? fonte;
  final String? formula;
  final String? experimento;
  final bool padrao;
  final String key;

  Pop(this.id, this.descricao, this.key, {this.conceito, this.fonte, this.formula, this.experimento, this.padrao = false});

  @override
  String toString() {
    return 'Dado{id: $id, descricao: $descricao}';
  }
}

class DadosPop {
  final int id;
  final int idPop;
  final double bird;
  final double die;
  final double time;

  DadosPop(this.id, this.idPop, this.bird, this.die, this.time);

}