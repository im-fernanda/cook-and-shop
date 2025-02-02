import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print('E-mail de recuperação enviado');
    } catch (e) {
      print('Erro ao enviar e-mail de recuperação: $e');
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  String? getCurrentUserEmail() {
    return _firebaseAuth.currentUser!.email;
  }

  String? getCurrentUserId() {
    return _firebaseAuth.currentUser?.uid;
  }
}
