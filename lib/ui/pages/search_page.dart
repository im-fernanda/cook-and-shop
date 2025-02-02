import 'package:cook_and_shop/ui/pages/recipe_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api/api_service.dart';
import '../widgets/recipes/recipe_search_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isInitialized = false;
  late final ApiService _apiService;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _hasMore = true;
  int _offset = 0;
  List<dynamic> _searchResults = [];

  // Filtros
  int _maxTime = 60;
  String? _cuisine;
  String? _mealType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _apiService = context.read<ApiService>();
      _scrollController.addListener(_onScroll);
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        _hasMore) {
      _loadMoreRecipes();
    }
  }

  Future<void> _loadMoreRecipes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final newRecipes = await _apiService.searchRecipesWithFilters(
        searchText: _searchController.text,
        maxReadyTime: _maxTime,
        cuisine: _cuisine,
        mealType: _mealType,
        offset: _offset,
      );

      setState(() {
        if (newRecipes.isEmpty) {
          _hasMore = false;
        } else {
          _searchResults.addAll(newRecipes);
          _offset += newRecipes.length;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar mais receitas: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchRecipes() async {
    setState(() {
      _isLoading = true;
      _offset = 0;
      _hasMore = true;
      _searchResults.clear();
    });

    try {
      final recipes = await _apiService.searchRecipesWithFilters(
        searchText: _searchController.text,
        maxReadyTime: _maxTime,
        cuisine: _cuisine,
        mealType: _mealType,
        offset: _offset,
      );

      setState(() {
        _searchResults = recipes;
        _offset += recipes.length;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar receitas: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Receitas'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Busque ingredientes/receitas..',
                prefixIcon: Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: _showFilterBottomSheet,
                    ),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _searchRecipes();
                }
              },
            ),
          ),
          if (_isLoading && _offset == 0)
            Expanded(
              child: _buildLoadingIndicator(),
            )
          else if (_searchResults.isEmpty)
            const Expanded(
              child: Center(child: Text('Nenhuma receita encontrada')),
            )
          else
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _searchResults.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _searchResults.length) {
                    final recipe = _searchResults[index];
                    return RecipeSearchCard(
                      recipe: recipe,
                      onTap: (recipeId) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetails(
                              recipeId: recipeId,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return _buildLoadingIndicator();
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.9,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Text(
                          'Filtros',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),

                        // Tempo de preparo
                        Text(
                          'Tempo máximo de preparo: $_maxTime min',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Slider(
                          value: _maxTime.toDouble(),
                          min: 15,
                          max: 120,
                          divisions: 7,
                          label: '$_maxTime min',
                          activeColor: Theme.of(context).colorScheme.secondary,
                          onChanged: (value) {
                            setState(() {
                              _maxTime = value.round();
                            });
                          },
                        ),
                        SizedBox(height: 20),

                        // Tipo de Culinária
                        Text(
                          'Tipo de Culinária',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListView.builder(
                            itemCount: ApiService.cuisineTypes.length,
                            itemBuilder: (context, index) {
                              final cuisine = ApiService.cuisineTypes[index];
                              final isSelected = _cuisine == cuisine['value'];
                              return ListTile(
                                title: Text(cuisine['label']!),
                                trailing: isSelected
                                    ? Icon(Icons.check,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)
                                    : null,
                                onTap: () {
                                  setState(() {
                                    _cuisine = cuisine['value'];
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 20),

                        // Tipo de Refeição
                        Text(
                          'Tipo de Refeição',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListView.builder(
                            itemCount: ApiService.mealTypes.length,
                            itemBuilder: (context, index) {
                              final mealType = ApiService.mealTypes[index];
                              final isSelected = _mealType == mealType['value'];
                              return ListTile(
                                title: Text(mealType['label']!),
                                trailing: isSelected
                                    ? Icon(Icons.check,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)
                                    : null,
                                onTap: () {
                                  setState(() {
                                    _mealType = mealType['value'];
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 20),

                        // Botões

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _maxTime = 60;
                                    _cuisine = null;
                                    _mealType = null;
                                  });
                                },
                                child: Text('Limpar Filtros'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  side: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _searchRecipes();
                                },
                                child: Text('Aplicar Filtros'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
