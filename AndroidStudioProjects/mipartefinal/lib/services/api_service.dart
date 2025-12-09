import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/normativa.dart';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'https://adamix.net/medioambiente/api';

  static Future<List<Normativa>> getNormativas() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/normativas'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Normativa.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<Normativa?> getNormativa(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/normativas/$id'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Normativa.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> cambiarContrasena(String token, String nuevaContrasena) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/cambiar-contrasena'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'nueva_contrasena': nuevaContrasena}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> recuperarContrasena(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/recuperar-contrasena'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
