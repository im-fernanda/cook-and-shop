import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesService {
  final CollectionReference _favoritesCollection =
      FirebaseFirestore.instance.collection('favorites');

  Future<void> saveFavorite(Map<String, dynamic> recipe) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final docId = '${userId}_${recipe['id']}';

    await _favoritesCollection.doc(docId).set({
      ...recipe,
      'ownerId': userId,
      'docId': docId, // Combina o user e id da receita
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> isFavorite(String recipeId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final querySnapshot = await _favoritesCollection
          .where('ownerId', isEqualTo: userId)
          .where('id', isEqualTo: recipeId)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> removeFavorite(String recipeId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await _favoritesCollection.doc('${userId}_$recipeId').delete();
  }

  Stream<List<Map<String, dynamic>>> getFavorites() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return _favoritesCollection
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  Stream<bool> isFavoriteStream(int recipeId) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return _favoritesCollection
        .where('ownerId', isEqualTo: userId)
        .where('id', isEqualTo: recipeId)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }
}
