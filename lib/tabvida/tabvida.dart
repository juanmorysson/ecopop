import 'dart:ffi';

class TabVida {
  final int id;
  final String descricao;
  final String? fonte;
  final bool padrao;
  final String key;

  TabVida(this.id, this.descricao, this.key, {this.fonte, this.padrao = false});

  @override
  String toString() {
    return 'Dado{id: $id, descricao: $descricao}';
  }
}

class ClasseIdadeTabVida {
  final int id;
  final int idTabVida;
  final int idade_inicio;
  final int idade_fim;
  final int sobreviventes;

  ClasseIdadeTabVida(this.id, this.idTabVida, this.idade_inicio, this.idade_fim, this.sobreviventes);

  @override
  String toString() {
    return 'De $idade_inicio até $idade_fim}';
  }
}
