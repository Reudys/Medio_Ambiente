import 'dart:convert';
import 'package:http/http.dart' as http;

class Servicio {
  final String id;
  final String nombre;
  final String descripcion;
  final String icono; 

  Servicio({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.icono,
  });

  factory Servicio.fromJson(Map<String, dynamic> json) {
    return Servicio(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? 'Servicio',
      descripcion: json['descripcion'] ?? 'Sin descripción',
      icono: json['icono'] ?? '',
    );
  }
}

class MiembroEquipo {
  final String id;
  final String nombre;
  final String cargo;
  final String departamento; 
  final String fotoUrl;
  final String biografia; 

  MiembroEquipo({
    required this.id,
    required this.nombre,
    required this.cargo,
    required this.departamento,
    required this.fotoUrl,
    required this.biografia,
  });

  factory MiembroEquipo.fromJson(Map<String, dynamic> json) {
    return MiembroEquipo(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? 'Nombre no disponible',
      cargo: json['cargo'] ?? 'Cargo no especificado',
      departamento: json['departamento'] ?? '',
      fotoUrl: json['foto'] ?? '', 
      biografia: json['biografia'] ?? 'Sin biografía disponible.',
    );
  }
}

class Reporte {
  final String? id;
  final String titulo;
  final String descripcion;
  final String fotoBase64;
  final double latitud;
  final double longitud;
  final String? estado;
  final String? comentarioOficial;
  final DateTime? fecha;

  Reporte({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.fotoBase64,
    required this.latitud,
    required this.longitud,
    this.estado,
    this.comentarioOficial,
    this.fecha,
  });

  factory Reporte.fromJson(Map<String, dynamic> json) {
    return Reporte(
      id: json['id'] ?? '',
      titulo: json['titulo'] ?? 'Sin título',
      descripcion: json['descripcion'] ?? '',
      fotoBase64: json['foto'] ?? '',
      latitud: double.tryParse(json['latitud']?.toString() ?? '0') ?? 0.0,
      longitud: double.tryParse(json['longitud']?.toString() ?? '0') ?? 0.0,
      estado: json['estado'] ?? 'Pendiente',
      comentarioOficial: json['comentario_oficial'] ?? '',
      fecha: json['fecha'] != null ? DateTime.tryParse(json['fecha']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'foto': fotoBase64,
      'latitud': latitud.toString(),
      'longitud': longitud.toString(),
    };
  }
}

class MedioAmbienteService {
  final String _urlServicios = "https://adamix.net/medioambiente/servicios";
  final String _urlEquipo = "https://adamix.net/medioambiente/equipo";
  final String _urlReportes = "https://adamix.net/medioambiente/reportes";
  final String _urlCrearReporte = "https://adamix.net/medioambiente/crear_reporte";   

  Future<List<Servicio>> getServicios() async {
    try {
      final response = await http.get(Uri.parse(_urlServicios));

      if (response.statusCode == 200) {
        List<dynamic> lista = json.decode(response.body);
        return lista.map((item) => Servicio.fromJson(item)).toList();
      } else {
        throw Exception('Error al cargar servicios: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<MiembroEquipo>> getEquipo() async {
    try {
      final response = await http.get(Uri.parse(_urlEquipo));

      if (response.statusCode == 200) {
        List<dynamic> lista = json.decode(response.body);
        return lista.map((item) => MiembroEquipo.fromJson(item)).toList();
      } else {
        throw Exception('Error al cargar equipo: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> crearReporte(Reporte reporte) async {
    try {
      final response = await http.post(
        Uri.parse(_urlCrearReporte),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(reporte.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error al crear reporte: $e');
      return false;
    }
  }

  Future<List<Reporte>> getMisReportes() async {
    try {
      final response = await http.get(Uri.parse(_urlReportes));

      if (response.statusCode == 200) {
        List<dynamic> lista = json.decode(response.body);
        return lista.map((item) => Reporte.fromJson(item)).toList();
      } else {
        throw Exception('Error al cargar reportes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener reportes: $e');
      return [];
    }
  }
}