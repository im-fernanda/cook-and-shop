import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'recipes';

  Future<void> saveRecipe(Map<String, dynamic> recipe) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      // Usando o ID da receita da API como documento ID
      await _firestore
          .collection(_collectionName)
          .doc(recipe['id'].toString())
          .set({
        'id': recipe['id'],
        'title': recipe['title'],
        'image': recipe['image'],
        'readyInMinutes': recipe['readyInMinutes'],
        'servings': recipe['servings'],
        'sourceUrl': recipe['sourceUrl'],
        'ownerId': user.uid, // Adiciona o UID do proprietário
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Erro ao salvar receita: $e');
      throw Exception('Falha ao salvar receita no Firestore');
    }
  }

  Future<List<Map<String, dynamic>>> getRecipes() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .where('ownerId', isEqualTo: user.uid) // Filtra pelo UID do usuário
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Erro ao buscar receitas: $e');
      throw Exception('Falha ao buscar receitas do Firestore');
    }
  }

  Future<bool> isRecipeSaved(String recipeId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      DocumentSnapshot doc =
          await _firestore.collection(_collectionName).doc(recipeId).get();

      // Verifica se a receita existe e pertence ao usuário atual
      return doc.exists && doc['ownerId'] == user.uid;
    } catch (e) {
      print('Erro ao verificar receita: $e');
      return false;
    }
  }
}
