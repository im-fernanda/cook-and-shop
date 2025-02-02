import 'package:flutter/material.dart';
import 'package:cook_and_shop/ui/pages/category_recipes_page.dart';

class CategoryButtons extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {'title': 'Pães', 'key': 'bread'},
    {'title': 'Lanches', 'key': 'snacks'},
    {'title': 'Saladas', 'key': 'salads'},
    {'title': 'Drinks', 'key': 'drinks'},
    {'title': 'Marinada', 'key': 'marinade'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: categories.map((category) {
          return _buildCategoryButton(
              context, category['title']!, category['key']!);
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryButton(
      BuildContext context, String title, String categoryKey) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
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
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.secondary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          side: BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
        child: Text(title),
      ),
    );
  }
}
