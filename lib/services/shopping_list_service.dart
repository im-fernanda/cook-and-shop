import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShoppingListService {
  final CollectionReference _shoppingListCollection =
      FirebaseFirestore.instance.collection('shopping_list');
  final CollectionReference _preparedRecipesCollection =
      FirebaseFirestore.instance.collection('prepared_recipes');

  Future<void> addToShoppingList(Map<String, dynamic> recipe) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await _shoppingListCollection.doc('${userId}_${recipe['id']}').set({
      ...recipe,
      'ownerId': userId,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeFromList(String recipeId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await _shoppingListCollection.doc('${userId}_$recipeId').delete();
  }

  Stream<List<Map<String, dynamic>>> getShoppingList() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return _shoppingListCollection
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  Future<void> addToPreparedRecipes(Map<String, dynamic> recipe) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final recipeId = recipe['id'].toString();

    await _preparedRecipesCollection.doc('${userId}_$recipeId').set({
      ...recipe,
      'ownerId': userId,
      'preparedAt': FieldValue.serverTimestamp(),
      'timesPrepared': 1,
    });
  }

  Stream<List<Map<String, dynamic>>> getPreparedRecipes() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return _preparedRecipesCollection
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  Future<void> incrementTimesPrepared(
      String docId, int currentTimesPrepared) async {
    await _preparedRecipesCollection.doc(docId).update({
      'timesPrepared': currentTimesPrepared + 1,
    });
  }

  Future<void> markAsPrepared(Map<String, dynamic> recipe) async {
    final recipeId = recipe['id'].toString();
    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final docRef = _preparedRecipesCollection.doc('${userId}_$recipeId');
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Incrementa timesPrepared se já existe
        final currentTimesPrepared = docSnapshot.get('timesPrepared');
        await incrementTimesPrepared(docSnapshot.id, currentTimesPrepared);
      } else {
        // Adiciona nova receita às preparadas
        await addToPreparedRecipes(recipe);
      }

      await removeFromList(recipeId);
    } catch (e) {
      throw Exception('Erro ao marcar receita como preparada: $e');
    }
  }

  Future<void> updateShoppingList(String recipeId,
      Map<String, dynamic> recipeDetails, List<String> ingredients) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Converte a lista de strings em lista de maps
    final List<Map<String, dynamic>> formattedIngredients = ingredients
        .map((ingredient) => {
              'original': ingredient,
            })
        .toList();

    await _shoppingListCollection.doc('${userId}_$recipeId').set({
      'id': recipeId,
      'title': recipeDetails['title'],
      'image': recipeDetails['image'],
      'ingredients': formattedIngredients,
      'servings': recipeDetails['servings'],
      'readyInMinutes': recipeDetails['readyInMinutes'],
      'ownerId': userId,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> validateAndUpdateShoppingList(String recipeId,
      Map<String, dynamic> recipeDetails, List<String> ingredients) async {
    if (ingredients.isEmpty) {
      return false;
    }

    await updateShoppingList(recipeId, recipeDetails, ingredients);
    return true;
  }
}
