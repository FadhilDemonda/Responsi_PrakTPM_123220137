import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/film_model.dart';

class LocalFavorite {
  static Future<Box> _openBox(String username) async {
    return await Hive.openBox('favorite_films_$username');
  }

  static Future<String?> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  static Future<bool> isFavorite(String filmId) async {
    final username = await _getUsername();
    if (username == null) return false;
    final box = await _openBox(username);
    return box.containsKey(filmId);
  }

  static Future<void> addFavorite(Film film) async {
    final username = await _getUsername();
    if (username == null) return;
    final box = await _openBox(username);
    await box.put(film.id, film.toJson());
  }

  static Future<void> removeFavorite(String filmId) async {
    final username = await _getUsername();
    if (username == null) return;
    final box = await _openBox(username);
    await box.delete(filmId);
  }

  static Future<List<Film>> getFavorites() async {
    final username = await _getUsername();
    if (username == null) return [];
    final box = await _openBox(username);
    return box.values
        .map((e) => Film.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
