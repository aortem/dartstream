import 'package:aortem_firebase_dart_sdk/firebase_dart.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithPopup(AuthProvider provider) async {
    if (Firebase.apps.isEmpty) {
      throw Exception('FirebaseApp is not initialized.');
    }

    try {
      UserCredential userCredential = await _auth.signInWithPopup(provider);
      return userCredential;
    } catch (e) {
      throw Exception('Error signing in with popup: $e');
    }
  }

  Future<ConfirmationResult> startSignInWithPhoneNumber(
      String phoneNumber, RecaptchaVerifier applicationVerifier) async {
    if (Firebase.apps.isEmpty) {
      throw Exception('FirebaseApp is not initialized.');
    }

    try {
      ConfirmationResult confirmationResult =
          await _auth.signInWithPhoneNumber(phoneNumber, applicationVerifier);
      return confirmationResult;
    } catch (e) {
      throw Exception('Error starting phone number sign-in: $e');
    }
  }

  Future<UserCredential> confirmSignInWithPhoneNumber(
      ConfirmationResult confirmationResult, String verificationCode) async {
    if (Firebase.apps.isEmpty) {
      throw Exception('FirebaseApp is not initialized.');
    }

    try {
      UserCredential userCredential =
          await confirmationResult.confirm(verificationCode);
      return userCredential;
    } catch (e) {
      throw Exception('Error confirming phone number sign-in: $e');
    }
  }

  Future<UserCredential> signInWithEmailLink(
      {required String email, required String emailLink}) async {
    if (Firebase.apps.isEmpty) {
      throw Exception('FirebaseApp is not initialized.');
    }

    try {
      UserCredential userCredential =
          await _auth.signInWithEmailLink(email: email, emailLink: emailLink);
      return userCredential;
    } catch (e) {
      throw Exception('Error signing in with email link: $e');
    }
  }

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
