class Instituicao {
  final String? uuid;
  final int id;
  final String descricao;
  final String? sigla;

  Instituicao({this.uuid, required this.id, required this.descricao, this.sigla});

  @override
  String toString() {
    return '$descricao - $sigla - $uuid - $id';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Instituicao &&
              uuid == other.uuid;

}
