import 'dart:developer';

import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';

import '../firebase_app.dart';

class EmailPasswordAuth {
  final FirebaseAuth auth;

  EmailPasswordAuth(this.auth);

  Future<UserCredential?> signIn(String email, String password) async {
    final response = await auth.performRequest('signInWithPassword', {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    });
    if (response.statusCode == 200) {
      final userCredential = UserCredential.fromJson(response.body);
      auth.updateCurrentUser(userCredential.user);
      log("current user 123 ${userCredential.user}");
      FirebaseApp.instance.setCurrentUser(userCredential.user);

      return userCredential;
    } else {
      log('Error signing in: ${response.body}');
      return null;
    }
  }

  Future<UserCredential?> signUp(String email, String password) async {
    final response = await auth.performRequest('signUp', {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    });
    if (response.statusCode == 200) {
      final userCredential = UserCredential.fromJson(response.body);
      auth.updateCurrentUser(userCredential.user);

      FirebaseApp.instance.setCurrentUser(userCredential.user);

      return userCredential;
    } else {
      print('Error signing in: ${response.body}');
      return null;
    }
  }
}
