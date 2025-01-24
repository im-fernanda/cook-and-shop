import 'package:flutter/material.dart';
import '../../services/api/api_service.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _recipes = [];

  void _searchRecipes(String query) async {
    final recipes = await _apiService.searchRecipes(query);
    setState(() {
      _recipes = recipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buscar Receitas')),
      body: Column(
        children: [
          TextField(
            onSubmitted: _searchRecipes,
            decoration: InputDecoration(labelText: 'Digite uma receita'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                final recipe = _recipes[index];
                return ListTile(
                  title: Text(recipe['title']),
                  onTap: () {}, // Navegar para detalhes da receita
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
