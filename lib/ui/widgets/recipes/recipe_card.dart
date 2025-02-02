import 'package:flutter/material.dart';
import 'recipe_card_content.dart';

class RecipeCard extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final VoidCallback onTap;

  const RecipeCard({
    Key? key,
    required this.recipe,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: RecipeCardContent(
          imageUrl: recipe['image'] ?? '',
          title: recipe['title'] ?? '',
          readyInMinutes: recipe['readyInMinutes']?.toString() ?? '0',
        ),
      ),
    );
  }
}
