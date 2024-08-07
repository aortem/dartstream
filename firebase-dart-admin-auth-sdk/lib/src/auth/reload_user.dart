import 'dart:developer';

import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user.dart';

class ReloadUser {
  final FirebaseAuth auth;

  ReloadUser({required this.auth});

  Future<User> reloadUser(String? idToken) async {
    try {
      assert(idToken != null, 'Id token cannot be null');
      final response = await auth.performRequest(
        'lookup',
        {
          "idToken": idToken,
        },
      );

      User user = User.fromJson((response['users'] as List)[0]);

      auth.updateCurrentUser(user);
      return user;
    } catch (e) {
      print('Reload user action failed: $e');
      throw FirebaseAuthException(
        code: 'reload-user',
        message: 'Failed to set reload user',
      );
    }
  }
}
