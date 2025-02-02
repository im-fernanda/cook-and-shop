import 'package:flutter/material.dart';

class RecipeSearchCard extends StatelessWidget {
  final dynamic recipe;
  final Function(int) onTap;

  const RecipeSearchCard({
    Key? key,
    required this.recipe,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(recipe['id']),
      child: Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 12),
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  recipe['image'] ?? '',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child: Center(
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: Icon(Icons.restaurant, color: Colors.grey[400]),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            recipe['title'] ?? '',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${recipe['servings'] ?? '0'} porções',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.timer,
                            size: 16,
                            color: Theme.of(context).colorScheme.secondary),
                        const SizedBox(width: 4),
                        Text(
                          'Pronto em ${recipe['readyInMinutes']?.toString() ?? '0'} Min',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
