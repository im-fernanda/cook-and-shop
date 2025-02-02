import 'package:cook_and_shop/services/favorites_service.dart';
import 'package:cook_and_shop/ui/pages/recipe_details.dart';
import 'package:cook_and_shop/ui/widgets/recipes/recipe_card.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  final FavoritesService _favoritesService = FavoritesService();

  FavoritesPage({Key? key}) : super(key: key);

  Future<void> _removeFromFavorites(
      String recipeId, BuildContext context) async {
    try {
      await _favoritesService.removeFavorite(recipeId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removida dos favoritos!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao remover dos favoritos: $e')),
      );
    }
  }

  void _navigateToRecipeDetails(BuildContext context, dynamic recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetails(recipeId: recipe['id']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _favoritesService.getFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma receita favoritada.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final favoriteRecipes = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.75,
              ),
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];
                return Stack(
                  children: [
                    RecipeCard(
                      recipe: recipe,
                      onTap: () => _navigateToRecipeDetails(context, recipe),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => _removeFromFavorites(
                          recipe['id'].toString(),
                          context,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
