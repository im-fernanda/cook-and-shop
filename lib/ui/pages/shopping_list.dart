import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/shopping_list_service.dart';
import 'list_details.dart';
import 'package:cook_and_shop/ui/pages/recipe_details.dart';

class ShoppingListPage extends StatelessWidget {
  final ShoppingListService _shoppingListService = ShoppingListService();
  ShoppingListPage({Key? key}) : super(key: key);

  Future<void> _removeRecipe(String recipeId, BuildContext context) async {
    try {
      await _shoppingListService.removeFromList(recipeId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removida com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao remover receita: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Listas'),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.red,
            tabs: [
              Tab(text: 'A Comprar'),
              Tab(text: 'Preparadas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab Lista de Compras
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: _shoppingListService.getShoppingList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhuma receita na lista de compras.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                final recipes = snapshot.data!;

                return ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return Dismissible(
                      key: Key(recipe['id'].toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        _removeRecipe(recipe['id'].toString(), context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ListDetailsPage(recipeData: recipe),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                  ),
                                  child: Image.network(
                                    recipe['image'] ?? '',
                                    height: 140,
                                    width: 140,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          recipe['title'] ?? 'Sem título',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(Icons.room_service,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                            SizedBox(width: 4),
                                            Text(
                                              '${recipe['servings']}',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                            ),
                                            SizedBox(width: 16),
                                            Icon(Icons.timer,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                            SizedBox(width: 4),
                                            Text(
                                              '${recipe['readyInMinutes']} min',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Colors.redAccent, size: 28),
                                  onPressed: () => _removeRecipe(
                                      recipe['id'].toString(), context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // Tab Receitas Preparadas
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: _shoppingListService.getPreparedRecipes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhuma receita preparada.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                final recipes = snapshot.data!;

                return ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetails(
                                recipeId: recipe['id'],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                ),
                                child: Image.network(
                                  recipe['image'] ?? '',
                                  height: 140,
                                  width: 140,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recipe['title'] ?? 'Sem título',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Text(
                                  '${recipe['timesPrepared'] ?? 1}x',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
