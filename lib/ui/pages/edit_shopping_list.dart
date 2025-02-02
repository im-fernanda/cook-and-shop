import 'package:flutter/material.dart';

import '../../services/shopping_list_service.dart';

class EditShoppingListPage extends StatefulWidget {
  final Map<String, dynamic> recipeDetails;

  const EditShoppingListPage({Key? key, required this.recipeDetails})
      : super(key: key);

  @override
  _EditShoppingListPageState createState() => _EditShoppingListPageState();
}

class _EditShoppingListPageState extends State<EditShoppingListPage> {
  final ShoppingListService _shoppingListService = ShoppingListService();
  List<String> _shoppingList = [];
  final TextEditingController _itemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializa a lista de compras com os ingredientes da receita
    _shoppingList = (widget.recipeDetails['extendedIngredients'] as List)
        .map((ingredient) => ingredient['original'] as String)
        .toList();
  }

  void _addItem(String item) {
    if (item.isNotEmpty) {
      setState(() {
        _shoppingList.add(item);
      });
      _itemController.clear();
    }
  }

  void _removeItem(String item) {
    setState(() {
      _shoppingList.remove(item);
    });
  }

  Future<void> _saveToFirestore() async {
    try {
      final recipeId = widget.recipeDetails['id'];
      final success = await _shoppingListService.validateAndUpdateShoppingList(
        recipeId.toString(),
        widget.recipeDetails,
        _shoppingList,
      );

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'A lista de compras está vazia! Adicione itens antes de salvar.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lista salva com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar lista: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Lista de Compras'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveToFirestore,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _shoppingList.length,
              itemBuilder: (context, index) {
                final item = _shoppingList[index];
                return ListTile(
                  title: Text(item),
                  trailing: IconButton(
                    icon: Icon(Icons.delete,
                        color: Theme.of(context).colorScheme.secondary),
                    onPressed: () => _removeItem(item),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: InputDecoration(
                      labelText: 'Adicionar Item',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        // Mantém a borda visível ao selecionar
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _addItem(_itemController.text),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveToFirestore, // Salva no Firebase
                icon: Icon(Icons.save),
                label: Text('Salvar Lista'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Cor de fundo do botão
                  foregroundColor: Theme.of(context)
                      .colorScheme
                      .primary, // Cor do texto/ícone
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
