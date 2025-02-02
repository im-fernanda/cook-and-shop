import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api/api_service.dart';
import '../../services/favorites_service.dart';
import '../../services/shopping_list_service.dart';
import '../widgets/recipes/recipe_details_content.dart';
import '../widgets/recipes/recipe_details_header.dart';
import 'edit_shopping_list.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeDetails extends StatefulWidget {
  final int recipeId;
  const RecipeDetails({Key? key, required this.recipeId}) : super(key: key);

  @override
  _RecipeDetailsState createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  late final FavoritesService _favoritesService;
  late final ShoppingListService _shoppingListService;
  late final ApiService _apiService;
  late final String userId;

  bool _isInitialized = false;
  bool _isLoading = true;
  Map<String, dynamic>? _recipeDetails;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _favoritesService = context.read<FavoritesService>();
      _shoppingListService = context.read<ShoppingListService>();
      _apiService = context.read<ApiService>();
      userId = FirebaseAuth.instance.currentUser!.uid;
      _loadRecipeDetails();
      _isInitialized = true;
    }
  }

  void _generateShoppingList() async {
    if (_recipeDetails == null) return;

    try {
      await _shoppingListService.addToShoppingList({
        'id': widget.recipeId,
        'title': _recipeDetails!['title'],
        'image': _recipeDetails!['image'],
        'servings': _recipeDetails!['servings'],
        'readyInMinutes': _recipeDetails!['readyInMinutes'],
        'ingredients': _recipeDetails!['extendedIngredients'],
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              EditShoppingListPage(recipeDetails: _recipeDetails!),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar Ã  lista de compras: $e')),
      );
    }
  }

  Future<void> _loadRecipeDetails() async {
    try {
      final details = await _apiService.getRecipeCard(widget.recipeId);
      setState(() {
        _recipeDetails = details;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Erro ao carregar detalhes: $e');
    }
  }

  void _toggleFavorite(bool isFavorite) async {
    if (_recipeDetails == null) return;

    try {
      if (isFavorite) {
        await _favoritesService.removeFavorite(widget.recipeId.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Removida dos favoritos'),
              duration: Duration(seconds: 2)),
        );
      } else {
        await _favoritesService.saveFavorite({
          'id': widget.recipeId,
          'title': _recipeDetails!['title'],
          'image': _recipeDetails!['image'],
          'servings': _recipeDetails!['servings'],
          'readyInMinutes': _recipeDetails!['readyInMinutes'],
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Adicionada aos favoritos'),
              duration: Duration(seconds: 2)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar favoritos: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ),
        ),
      );
    }

    if (_recipeDetails == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text('Erro ao carregar receita'),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                _recipeDetails!['image'] ?? '',
                fit: BoxFit.cover,
              ),
            ),
            leading: Container(
              margin: EdgeInsets.only(left: 10),

              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.onPrimary,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ], // Fechamento do boxShadow
              ), // Fechamento do BoxDecoration
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 16),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.onPrimary,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: StreamBuilder<bool>(
                  stream: _favoritesService.isFavoriteStream(widget.recipeId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Icon(Icons.error, color: Colors.red);
                    }

                    final isFavorite = snapshot.data ?? false;
                    return GestureDetector(
                      onTap: () => _toggleFavorite(isFavorite),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 25,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                RecipeDetailsHeader(
                  title: _recipeDetails!['title'] ?? '',
                  score: _recipeDetails!['spoonacularScore']?.round() ?? 0,
                  readyInMinutes: _recipeDetails!['readyInMinutes'] ?? 0,
                  servings: _recipeDetails!['servings'] ?? 0,
                  pricePerServing: double.parse(
                      _recipeDetails!['pricePerServing'].toString()),
                ),
                SizedBox(height: 20),
                RecipeDetailsContent(
                  recipeDetails: _recipeDetails!,
                  onGenerateShoppingList: _generateShoppingList,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
