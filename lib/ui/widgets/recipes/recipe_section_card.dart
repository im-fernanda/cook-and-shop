import 'package:flutter/material.dart';
import 'package:cook_and_shop/ui/pages/recipe_details.dart';

class RecipeSectionCard extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeSectionCard({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetails(recipeId: recipe['id']),
          ),
        );
      },
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                recipe['image'] ?? '',
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe['title'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.timer,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Pronto em ${recipe['readyInMinutes']?.toString() ?? '0'} Min',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
