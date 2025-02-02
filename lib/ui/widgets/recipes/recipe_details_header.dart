import 'package:flutter/material.dart';

class RecipeDetailsHeader extends StatelessWidget {
  final String title;
  final int score;
  final int readyInMinutes;
  final int servings;
  final double pricePerServing;

  const RecipeDetailsHeader({
    Key? key,
    required this.title,
    required this.score,
    required this.readyInMinutes,
    required this.servings,
    required this.pricePerServing,
  }) : super(key: key);

  Widget _buildInfoItem(
      BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.secondary),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star,
                        color: Theme.of(context).colorScheme.primary, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '$score',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInfoItem(
              context,
              Icons.timer,
              '$readyInMinutes',
              'Min',
            ),
            _buildInfoItem(
              context,
              Icons.room_service,
              '$servings',
              'Servings',
            ),
            _buildInfoItem(
              context,
              Icons.attach_money,
              '\$ $pricePerServing',
              'Price/Serving',
            ),
          ],
        ),
      ],
    );
  }
}
