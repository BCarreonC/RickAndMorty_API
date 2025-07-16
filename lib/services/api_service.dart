import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';

/// Servicio encargado de obtener datos desde la API de Rick and Morty.
class ApiService {
  /// Obtiene una lista de personajes desde la API pública de Rick and Morty.
  ///
  /// Realiza una petición HTTP GET al endpoint `/api/character`, decodifica
  /// el JSON de respuesta y lo convierte en una lista de objetos [Character].
  ///
  /// Lanza una excepción si ocurre algún error durante la petición.
  static Future<List<Character>> fetchCharacters() async {
    final url = Uri.parse('https://rickandmortyapi.com/api/character');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((json) => Character.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar personajes');
    }
  }
}
