import 'dart:developer';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/additional_user_info.dart';
import '../firebase_app.dart';

class EmailPasswordAuth {
  final FirebaseAuth auth;

  EmailPasswordAuth(this.auth);

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      final response = await auth.performRequest('signInWithPassword', {
        'email': email,
        'password': password,
        'returnSecureToken': true,
      });

      if (response.statusCode == 200) {
        final userData = response.body;
        final user = User.fromJson(userData);
        final additionalUserInfo = AdditionalUserInfo(
          isNewUser: false,
          providerId: 'password',
        );

        final userCredential = UserCredential(
          user: user,
          additionalUserInfo: additionalUserInfo,
          operationType: 'signIn',
        );

        auth.updateCurrentUser(userCredential.user);
        FirebaseApp.instance.setCurrentUser(userCredential.user);

        return userCredential;
      } else {
        log('Error signing in: ${response.body}');
        return null;
      }
    } catch (e) {
      log('Exception during sign in: $e');
      return null;
    }
  }

  Future<UserCredential?> signUp(String email, String password) async {
    try {
      final response = await auth.performRequest('signUp', {
        'email': email,
        'password': password,
        'returnSecureToken': true,
      });

      if (response.statusCode == 200) {
        final userData = response.body;
        final user = User.fromJson(userData);
        final additionalUserInfo = AdditionalUserInfo(
          isNewUser: true,
          providerId: 'password',
        );

        final userCredential = UserCredential(
          user: user,
          additionalUserInfo: additionalUserInfo,
          operationType: 'signUp',
        );

        auth.updateCurrentUser(userCredential.user);
        FirebaseApp.instance.setCurrentUser(userCredential.user);

        return userCredential;
      } else {
        log('Error signing up: ${response.body}');
        return null;
      }
    } catch (e) {
      log('Exception during sign up: $e');
      return null;
    }
  }
}
