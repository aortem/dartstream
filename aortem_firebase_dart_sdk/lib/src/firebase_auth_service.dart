import 'package:aortem_firebase_dart_sdk/firebase_dart.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithCustomToken(String token) async {
    if (Firebase.apps.isEmpty) {
      throw Exception('FirebaseApp is not initialized.');
    }

    try {
      UserCredential userCredential = await _auth.signInWithCustomToken(token);
      return userCredential;
    } catch (e) {
      throw Exception('Error signing in with custom token: $e');
    }
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    if (Firebase.apps.isEmpty) {
      throw Exception('FirebaseApp is not initialized.');
    }

    try {
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      throw Exception('Error signing in with credential: $e');
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    if (Firebase.apps.isEmpty) {
      throw Exception('FirebaseApp is not initialized.');
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } catch (e) {
      throw Exception('Error signing in with email and password: $e');
    }
  }
}
