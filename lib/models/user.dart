class User {
  final String nombre;
  final String apellido;
  final String email;
  final String token;

  User({
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
    );
  }
}
