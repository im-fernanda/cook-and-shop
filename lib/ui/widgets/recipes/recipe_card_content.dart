import 'package:flutter/material.dart';

class RecipeCardContent extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String readyInMinutes;

  const RecipeCardContent({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.readyInMinutes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(12),
          ),
          child: Image.network(
            imageUrl,
            height: 140,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
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
                    'Pronto em $readyInMinutes Min',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
