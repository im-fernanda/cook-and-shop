import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'api.spoonacular.com';
  final String _apiKey =
      'b53455fbee1f45fb9226b42a0e260491'; // Substitua pela sua chave da API

  Future<List<dynamic>> searchRecipes(String query) async {
    final uri = Uri.https(_baseUrl, '/recipes/complexSearch', {
      'query': query,
      'apiKey': _apiKey,
    });

    try {
      // Faz a requisição HTTP com timeout
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Decodifica a resposta e retorna os resultados
        final data = json.decode(response.body);
        print(
            'Resposta completa da API: ${response.body}'); // Log para depuração
        return data['results'] ??
            []; // Retorna os resultados ou uma lista vazia
      } else {
        throw Exception(
            'Erro ao buscar receitas: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erro na requisição: $e'); // Log para erros inesperados
      throw Exception('Erro ao processar a requisição: $e');
    }
  }
}
