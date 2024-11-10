import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class SignInWithPopupViewModel extends ChangeNotifier {
  final FirebaseAuth _auth;
  User? user;
  bool isLoading = false;
  String? errorMessage;
  StreamSubscription<User?>? _authStateSubscription;

  SignInWithPopupViewModel(this._auth) {
    _setupAuthListener();
  }

  void _setupAuthListener() {
    _authStateSubscription = _auth.onAuthStateChanged().listen(
      (User? updatedUser) {
        user = updatedUser;
        notifyListeners();
      },
      onError: (error) {
        errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

  Future<void> signInWithGoogle() async {
    await _signInWithPopup(
      GoogleAuthProvider(),
      'YOUR_CLIENT_ID', //Replace with your actual google ClientID
    );
  }

  Future<void> signInWithFacebook() async {
    await _signInWithPopup(
      FacebookAuthProvider(),
      'YOUR_FACEBOOK_APP_ID', // Replace with your actual Facebook App ID
    );
  }

  Future<void> _signInWithPopup(AuthProvider provider, String clientId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final userCredential = await _auth.signInWithPopup(provider, clientId);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'An unexpected error occurred';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}
