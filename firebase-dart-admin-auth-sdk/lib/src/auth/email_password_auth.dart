import 'dart:developer';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

///emailpasswordauth
class EmailPasswordAuth {
  ///auth
  final FirebaseAuth auth;

  ///emailpassword
  EmailPasswordAuth(this.auth);

  ///signin
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      final response = await auth.performRequest('signInWithPassword', {
        'email': email,
        'password': password,
        'returnSecureToken': true,
      });
      print(response.body.toString());

      if (response.statusCode == 200) {
        final userCredential = UserCredential.fromJson(response.body);
        auth.updateCurrentUser(userCredential.user);
        log("current user 123 ${userCredential.user.idToken}");
        FirebaseApp.instance.setCurrentUser(userCredential.user);

        return userCredential;
      } else {
        final error = response.body['error'];
        throw FirebaseAuthException(
          code: error['message'] ?? 'unknown-error',
          message: error['message'] ?? 'An unknown error occurred',
        );
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        rethrow;
      }
      throw FirebaseAuthException(code: 'auth-error', message: e.toString());
    }
  }

  ///signup
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
