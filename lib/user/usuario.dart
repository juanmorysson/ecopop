class Usuario {
  final int id;
  final String email;
  final String? displayName;
  final String? instituicao;
  final String? key;

  Usuario(this.id, this.email, this.displayName, this.instituicao, this.key);

  @override
  String toString() {
    return 'email: $email, display_name: $displayName';
  }
}
