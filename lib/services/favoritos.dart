import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritosService {
  static const _key = 'favoritos_ruta_cultural';

  /// Devuelve set de ids favoritos
  static Future<Set<String>> obtenerFavoritos() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_key);
    if (raw == null || raw.isEmpty) return <String>{};
    final List<dynamic> list = json.decode(raw);
    return list.map((e) => e.toString()).toSet();
  }

  static Future<void> guardarFavoritos(Set<String> ids) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_key, json.encode(ids.toList()));
  }

  static Future<bool> esFavorito(String id) async {
    final s = await obtenerFavoritos();
    return s.contains(id);
  }

  static Future<void> alternarFavorito(String id) async {
    final s = await obtenerFavoritos();
    if (s.contains(id)) {
      s.remove(id);
    } else {
      s.add(id);
    }
    await guardarFavoritos(s);
  }
}
