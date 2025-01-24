import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesService {
  final CollectionReference _favoritesCollection =
      FirebaseFirestore.instance.collection('favorites');

  Future<void> saveFavorite(Map<String, dynamic> recipe) async {
    await _favoritesCollection.add(recipe);
  }

  Stream<List<Map<String, dynamic>>> getFavorites() {
    return _favoritesCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList());
  }
}
