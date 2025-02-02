import 'package:flutter/material.dart';
import 'package:cook_and_shop/ui/pages/category_recipes_page.dart';
import 'recipe_section_card.dart';

class RecipeSection extends StatelessWidget {
  final String title;
  final String categoryKey;
  final List<dynamic> recipes;

  const RecipeSection({
    Key? key,
    required this.title,
    required this.categoryKey,
    required this.recipes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recipes.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryRecipesPage(
                        title: title,
                        categoryKey: categoryKey,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Ver todas',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              return RecipeSectionCard(recipe: recipes[index]);
            },
          ),
        ),
      ],
    );
  }
}
