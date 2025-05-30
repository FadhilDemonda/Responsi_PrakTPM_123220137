import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/film_model.dart';

class ApiService {
  final String baseUrl =
      'https://681388b3129f6313e2119693.mockapi.io/api/v1/movie';

  Future<List<Film>> fetchFilms() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Film.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load films');
    }
  }
}
