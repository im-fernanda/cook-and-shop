import 'package:flutter/material.dart';

class RecipeDetailsContent extends StatelessWidget {
  final Map<String, dynamic> recipeDetails;
  final VoidCallback onGenerateShoppingList;

  const RecipeDetailsContent({
    Key? key,
    required this.recipeDetails,
    required this.onGenerateShoppingList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final steps =
        recipeDetails['analyzedInstructions']?[0]['steps'] as List? ?? [];
    final ingredients = recipeDetails['extendedIngredients'] as List? ?? [];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero, // Remove o padding padrão do ListView
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = ingredients[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://spoonacular.com/cdn/ingredients_100x100/${ingredient['image']}',
                    ),
                    backgroundColor: Colors.grey[200],
                  ),
                  title: Text(ingredient['original'] ?? ''),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Preparation Steps',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: steps.length,
              itemBuilder: (context, index) {
                final step = steps[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${step['number']}'),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text(step['step'] ?? ''),
                );
              },
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: onGenerateShoppingList,
                icon: Icon(Icons.shopping_cart),
                label: Text('Gerar Lista de Compras'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
