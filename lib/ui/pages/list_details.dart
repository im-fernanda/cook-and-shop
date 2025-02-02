import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/pdf_service.dart';
import '../../services/shopping_list_service.dart';

class ListDetailsPage extends StatefulWidget {
  final Map<String, dynamic> recipeData;

  const ListDetailsPage({Key? key, required this.recipeData}) : super(key: key);

  @override
  _ListDetailsPageState createState() => _ListDetailsPageState();
}

class _ListDetailsPageState extends State<ListDetailsPage> {
  late final ShoppingListService _shoppingListService;
  late final PdfService _pdfService;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _shoppingListService = context.read<ShoppingListService>();
      _pdfService = context.read<PdfService>();
      _isInitialized = true;
    }
  }

  Future<void> _markAsPrepared(BuildContext context) async {
    try {
      await _shoppingListService.markAsPrepared(widget.recipeData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Receita marcada como preparada!'),
            duration: Duration(seconds: 2),
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao marcar receita como preparada: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = widget.recipeData['ingredients'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipeData['title'] ?? 'Detalhes da Lista'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              try {
                await _pdfService.generateIngredientsList(
                  widget.recipeData['title'],
                  ingredients,
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('PDF gerado com sucesso!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao gerar PDF: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ingredients',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  final ingredient = ingredients[index] as Map<String, dynamic>;
                  return ListTile(
                    leading: const Icon(Icons.radio_button_unchecked,
                        color: Colors.green),
                    title: Text(
                      ingredient['original'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _markAsPrepared(context),
                icon: Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: const Text('Marcar como preparada'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
