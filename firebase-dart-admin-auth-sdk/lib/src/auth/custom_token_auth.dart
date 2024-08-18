import 'dart:async';
import 'dart:convert';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';

class CustomTokenAuth {
  final FirebaseAuth auth;

  CustomTokenAuth(this.auth);

  Future<UserCredential> signInWithCustomToken(String token) async {
    try {
      final response = await auth.performRequest('signInWithCustomToken', {
        'token': token,
        'returnSecureToken': true,
      });

      final userCredential = UserCredential.fromJson(response.body);
      auth.updateCurrentUser(userCredential.user);
      return userCredential;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'custom-token-sign-in-error',
        message: 'Failed to sign in with custom token: ${e.toString()}',
      );
    }
  }
}
