class Normativa {
  final int id;
  final String titulo;
  final String descripcion;
  final String fecha;
  final String contenido;

  Normativa({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.contenido,
  });

  factory Normativa.fromJson(Map<String, dynamic> json) {
    return Normativa(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      fecha: json['fecha'] ?? '',
      contenido: json['contenido'] ?? '',
    );
  }
}
