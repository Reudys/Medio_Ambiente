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

class MedioAmbienteService {
  final String _urlServicios = "https://adamix.net/medioambiente/servicios";
  final String _urlEquipo = "https://adamix.net/medioambiente/equipo";   

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
}