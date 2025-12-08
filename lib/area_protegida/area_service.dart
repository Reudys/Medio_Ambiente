import 'dart:convert';
import 'package:http/http.dart' as http;

import 'area_model.dart';

class AreaService {
  final String baseUrl = "https://api-areas-protegida.onrender.com/areas";

  Future<List<Area>> getAreas() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Area.fromJson(e)).toList();
    } else {
      throw Exception("Error al cargar las áreas");
    }
  }

  Future<Area?> getAreaById(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return Area.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }
}
