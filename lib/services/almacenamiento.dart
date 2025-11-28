import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static const String _keyUsuarios = 'usuarios_json';

  // Cargar lista de usuarios (retorna List)
  static Future<List<dynamic>> cargarUsuarios() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_keyUsuarios);

      debugPrint('UserStorage cargarUsuarios -> jsonString: $jsonString');

      if (jsonString == null || jsonString.isEmpty) return [];
      final data = jsonDecode(jsonString);
      if (data is List) return data;
      return [];
    } catch (e, st) {
      debugPrint('Error cargarUsuarios: $e\n$st');
      return [];
    }
  }

  // Guardar lista completa de usuarios
  static Future<void> guardarUsuarios(List usuarios) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String jsonString = jsonEncode(usuarios);
      await prefs.setString(_keyUsuarios, jsonString);
      debugPrint('UserStorage guardarUsuarios -> guardado OK');
    } catch (e, st) {
      debugPrint('Error guardarUsuarios: $e\n$st');
      rethrow;
    }
  }

  // Agregar un usuario nuevo
  static Future<void> agregarUsuario(Map<String, dynamic> nuevoUsuario) async {
    try {
      List usuarios = await cargarUsuarios();
      usuarios.add(nuevoUsuario);
      await guardarUsuarios(usuarios);
    } catch (e, st) {
      debugPrint('Error agregarUsuario: $e\n$st');
      rethrow;
    }
  }
}
