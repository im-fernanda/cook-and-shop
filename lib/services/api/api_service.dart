import 'dart:convert';
import 'package:http/http.dart' as http;

import '../firestore_service.dart';

class ApiService {
  final String _baseUrl = 'api.spoonacular.com';
  final String _apiKey = 'SUA-CHAVE';


  late final FirestoreService _firestoreService;

  bool _isInitialized = false;

  void initialize(FirestoreService firestoreService) {
    if (!_isInitialized) {
      _firestoreService = firestoreService;
      _isInitialized = true;
    }
  }

  Future<List<dynamic>> searchRecipes(String query) async {
    final uri = Uri.https(_baseUrl, '/recipes/complexSearch', {
      'query': query,
      'apiKey': _apiKey,
      'addRecipeInformation': 'true',
      'number': '10',
      'type': query,
    });

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Log para depuração
        print('Buscando receitas para: $query');
        final results = data['results'] as List;
        results.forEach((recipe) {
          print('Receita: ${recipe['title']}');
          print('Tempo de preparo: ${recipe['readyInMinutes']} minutos');
          print('Porções: ${recipe['servings']}');
          print('---');
        });

        return results;
      } else {
        print('Erro na API: ${response.statusCode}');
        print('Resposta: ${response.body}');
        throw Exception(
            'Erro ao buscar receitas: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
      throw Exception('Erro ao processar a requisição: $e');
    }
  }

  // Lista de tipos de culinária
  static final List<Map<String, String>> cuisineTypes = [
    {'label': 'Africana', 'value': 'African'},
    {'label': 'Asiática', 'value': 'Asian'},
    {'label': 'Americana', 'value': 'American'},
    {'label': 'Britânica', 'value': 'British'},
    {'label': 'Cajun', 'value': 'Cajun'},
    {'label': 'Caribenha', 'value': 'Caribbean'},
    {'label': 'Chinesa', 'value': 'Chinese'},
    {'label': 'Leste Europeu', 'value': 'Eastern European'},
    {'label': 'Europeia', 'value': 'European'},
    {'label': 'Francesa', 'value': 'French'},
    {'label': 'Alemã', 'value': 'German'},
    {'label': 'Grega', 'value': 'Greek'},
    {'label': 'Indiana', 'value': 'Indian'},
    {'label': 'Irlandesa', 'value': 'Irish'},
    {'label': 'Italiana', 'value': 'Italian'},
    {'label': 'Japonesa', 'value': 'Japanese'},
    {'label': 'Judaica', 'value': 'Jewish'},
    {'label': 'Coreana', 'value': 'Korean'},
    {'label': 'Latino Americana', 'value': 'Latin American'},
    {'label': 'Mediterrânea', 'value': 'Mediterranean'},
    {'label': 'Mexicana', 'value': 'Mexican'},
    {'label': 'Oriente Médio', 'value': 'Middle Eastern'},
    {'label': 'Nórdica', 'value': 'Nordic'},
    {'label': 'Sul', 'value': 'Southern'},
    {'label': 'Espanhola', 'value': 'Spanish'},
    {'label': 'Tailandesa', 'value': 'Thai'},
    {'label': 'Vietnamita', 'value': 'Vietnamese'},
  ];

  // Lista de tipos de refeição
  static final List<Map<String, String>> mealTypes = [
    {'label': 'Entrada', 'value': 'appetizer'},
    {'label': 'Bebida', 'value': 'beverage'},
    {'label': 'Pães', 'value': 'bread'},
    {'label': 'Café da Manhã', 'value': 'breakfast'},
    {'label': 'Sobremesa', 'value': 'dessert'},
    {'label': 'Drink', 'value': 'drink'},
    {'label': 'Petisco', 'value': 'fingerfood'},
    {'label': 'Prato Principal', 'value': 'main course'},
    {'label': 'Marinada', 'value': 'marinade'},
    {'label': 'Salada', 'value': 'salad'},
    {'label': 'Molho', 'value': 'sauce'},
    {'label': 'Acompanhamento', 'value': 'side dish'},
    {'label': 'Lanche', 'value': 'snack'},
    {'label': 'Sopa', 'value': 'soup'},
  ];

  // Método para construir os parâmetros de consulta com base nos filtros
  Map<String, String> _buildQueryParameters({
    String? searchText,
    int? maxReadyTime,
    String? cuisine,
    String? mealType,
    int offset = 0,
  }) {
    final Map<String, String> queryParams = {
      'apiKey': _apiKey,
      'addRecipeInformation': 'true',
      'number': '10',
      'query': searchText ?? '',
      'offset': offset.toString(),
    };

    if (maxReadyTime != null) {
      queryParams['maxReadyTime'] = maxReadyTime.toString();
    }

    if (cuisine != null) {
      queryParams['cuisine'] = cuisine;
    }

    if (mealType != null) {
      queryParams['type'] = mealType.toLowerCase();
    }

    return queryParams;
  }

  Future<List<dynamic>> searchRecipesWithFilters({
    String? searchText,
    int? maxReadyTime,
    String? cuisine,
    String? mealType,
    int offset = 0,
  }) async {
    final queryParams = _buildQueryParameters(
      searchText: searchText,
      maxReadyTime: maxReadyTime,
      cuisine: cuisine,
      mealType: mealType,
      offset: offset,
    );

    final uri = Uri.https(_baseUrl, '/recipes/complexSearch', queryParams);

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Resposta da busca avançada: ${response.body}');
        return data['results'] ?? [];
      } else {
        throw Exception(
            'Erro ao buscar receitas: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
      throw Exception('Erro ao processar a requisição: $e');
    }
  }

  Future<Map<String, dynamic>> getRecipeCard(int recipeId) async {
    final uri = Uri.https(_baseUrl, '/recipes/$recipeId/information', {
      'apiKey': _apiKey,
    });

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Erro ao buscar detalhes da receita: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
      throw Exception('Erro ao processar a requisição: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchPopularRecipes(String query) async {
    final uri = Uri.https(_baseUrl, '/recipes/complexSearch', {
      'query': query,
      'apiKey': _apiKey,
      'addRecipeInformation': 'true',
      'number': '10',
      'sort': 'popularity',
    });

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Log para depuração
        print('Buscando receitas para: $query');
        final results = data['results'] as List;

        results.forEach((recipe) {
          print('Receita: ${recipe['title']}');
          print('Tempo de preparo: ${recipe['readyInMinutes']} minutos');
          print('Porções: ${recipe['servings']}');
          print('---');
        });

        // Retorna apenas os campos necessários
        return results.map((recipe) {
          return {
            'id': recipe['id'],
            'title': recipe['title'],
            'image': recipe['image'],
            'readyInMinutes': recipe['readyInMinutes'],
            'servings': recipe['servings'],
          };
        }).toList();
      } else {
        print('Erro na API: ${response.statusCode}');
        print('Resposta: ${response.body}');
        throw Exception(
            'Erro ao buscar receitas: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
      throw Exception('Erro ao processar a requisição: $e');
    }
  }

  Future<List<dynamic>> fetchCategoryRecipes(String categoryKey,
      {int offset = 0}) async {
    final uri = Uri.https(_baseUrl, '/recipes/complexSearch', {
      'apiKey': _apiKey,
      'type': categoryKey,
      'addRecipeInformation': 'true',
      'number': '8',
      'offset': offset.toString(), // Paginação (começa do offset)
    });

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results'] ?? [];
      } else {
        throw Exception('Erro ao buscar receitas da categoria $categoryKey');
      }
    } catch (e) {
      print('Erro na requisição: $e');
      throw Exception('Erro ao processar a requisição: $e');
    }
  }
}
