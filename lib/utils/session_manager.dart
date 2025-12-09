import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class SessionManager {
  static const String _userKey = 'user_data';

  static Future<bool> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_userKey, json.encode({
      'nombre': user.nombre,
      'apellido': user.apellido,
      'email': user.email,
      'token': user.token,
    }));
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    if (userString != null) {
      final userMap = json.decode(userString);
      return User.fromJson(userMap);
    }
    return null;
  }

  static Future<bool> isLoggedIn() async {
    final user = await getUser();
    return user != null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  static Future<String?> getUserName() async {
    final user = await getUser();
    if (user != null) {
      return '${user.nombre} ${user.apellido}';
    }
    return null;
  }

  static Future<String?> getToken() async {
    final user = await getUser();
    return user?.token;
  }
}
