import 'package:flutter/material.dart';
import 'package:cook_and_shop/services/api/api_service.dart';
import 'package:cook_and_shop/ui/pages/recipe_details.dart';
import 'package:cook_and_shop/ui/widgets/recipes/recipe_card.dart';
import 'package:provider/provider.dart';

class CategoryRecipesPage extends StatefulWidget {
  final String title;
  final String categoryKey;

  const CategoryRecipesPage({
    Key? key,
    required this.title,
    required this.categoryKey,
  }) : super(key: key);

  @override
  _CategoryRecipesPageState createState() => _CategoryRecipesPageState();
}

class _CategoryRecipesPageState extends State<CategoryRecipesPage> {
  late final ApiService _apiService;
  List<dynamic> _recipes = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _offset = 0;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _apiService = context.read<ApiService>();
      _loadMoreRecipes();
      _isInitialized = true;
    }
  }

  Future<void> _loadMoreRecipes() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newRecipes = await _apiService
          .fetchCategoryRecipes(widget.categoryKey, offset: _offset);

      setState(() {
        _recipes.addAll(newRecipes);
        _offset += newRecipes.length;
        _hasMore = newRecipes.isNotEmpty;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar receitas: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToRecipeDetails(dynamic recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetails(
          recipeId: recipe['id'],
        ),
      ),
    );
  }

  bool _handleScrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
        !_isLoading &&
        _hasMore) {
      _loadMoreRecipes();
    }
    return false;
  }

  Widget _buildGridItem(BuildContext context, int index) {
    if (index == _recipes.length) {
      return const Center(child: CircularProgressIndicator());
    }

    final recipe = _recipes[index];
    return RecipeCard(
      recipe: recipe,
      onTap: () => _navigateToRecipeDetails(recipe),
    );
  }

  Widget _buildRecipeGrid() {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.75,
          ),
          itemCount: _recipes.length + (_hasMore ? 1 : 0),
          itemBuilder: _buildGridItem,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: _buildRecipeGrid(),
    );
  }
}
