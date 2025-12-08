class Area {
  final String id;
  final String area;
  final String provincia;
  final String tipo;
  final String descripcion;
  final String ubicacion;
  final String superficie;
  final String imagen;
  final double latitud;
  final double longitud;

  Area({
    required this.id,
    required this.area,
    required this.provincia,
    required this.tipo,
    required this.descripcion,
    required this.ubicacion,
    required this.superficie,
    required this.imagen,
    required this.latitud,
    required this.longitud,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json["id"].toString(),
      area: json["area"] ?? "",
      provincia: json["provincia"] ?? "",
      tipo: json["tipo"] ?? "",
      descripcion: json["descripcion"] ?? "",
      ubicacion: json["ubicacion"] ?? "",
      superficie: json["superficie"] ?? "",
      imagen: json["imagen"] ?? "",
      latitud: (json["latitud"] ?? 0).toDouble(),
      longitud: (json["longitud"] ?? 0).toDouble(),
    );
  }
}
