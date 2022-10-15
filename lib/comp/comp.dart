import 'dart:ffi';

class Comp {
  final int id;
  final String descricao;
  final String? fonte;
  final bool padrao;
  final String key;
  final String especie_a;
  final String especie_b;


  Comp(this.id, this.descricao, this.especie_a, this.especie_b, this.key, {this.fonte, this.padrao = false});

  @override
  String toString() {
    return 'Dado{id: $id, descricao: $descricao}';
  }
}

class DadosComp {
  final int id;
  final int idComp;
  final int qtd_especie_a;
  final int qtd_especie_b;
  final int tempo;

  DadosComp(this.id, this.idComp, this.qtd_especie_a, this.qtd_especie_b, this.tempo);

  @override
  String toString() {
    return 'Em tempo: $tempo ';
  }
}
