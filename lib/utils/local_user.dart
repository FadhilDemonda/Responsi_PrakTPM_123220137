import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static const _keyUsers = 'users';

  static Future<List<Map<String, String>>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyUsers);
    if (jsonString == null) return [];
    final List decoded = json.decode(jsonString);
    return decoded.map((e) => Map<String, String>.from(e)).toList();
  }

  static Future<void> addUser(String username, String password) async {
    final users = await _getUsers();
    users.add({'username': username, 'password': password});
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsers, json.encode(users));
  }

  static Future<bool> userExists(String username) async {
    final users = await _getUsers();
    return users.any((user) => user['username'] == username);
  }

  static Future<bool> checkUserPassword(
    String username,
    String password,
  ) async {
    final users = await _getUsers();
    return users.any(
      (user) => user['username'] == username && user['password'] == password,
    );
  }
}
