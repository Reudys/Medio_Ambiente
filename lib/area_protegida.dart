class AreaProtegida {
  final int id;
  final String nombre;
  final double lat;
  final double lng;
  final String descripcion;
  final String tipo;

  AreaProtegida({
    required this.id,
    required this.nombre,
    required this.lat,
    required this.lng,
    required this.descripcion,
    required this.tipo,
  });

  factory AreaProtegida.fromJson(Map<String, dynamic> json) {
    return AreaProtegida(
      id: json['id'],
      nombre: json['nombre'],
      lat: json['lat'],
      lng: json['lng'],
      descripcion: json['descripcion'],
      tipo: json['tipo'],
    );
  }
}
  