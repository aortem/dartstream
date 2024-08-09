import 'dart:developer';

import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user.dart';

class SetLanguageCode {
  final FirebaseAuth auth;
  SetLanguageCode({required this.auth});

  Future<User> setLanguageCode(String? idToken, String languageCode) async {
    try {
      assert(idToken != null, 'Id token cannot be null');
      assert(languageCode.isNotEmpty, 'language code cannot be empty');
      final response = await auth.performRequest(
        'update',
        {
          "idToken": idToken,
          "languageCode": languageCode,
        },
      );
      log("response is ${response.body} ");
      User user = User.fromJson(response.body);
      auth.updateCurrentUser(user);
      return user;
    } catch (e) {
      print('Set language code action failed: $e');
      throw FirebaseAuthException(
        code: 'set-langauge-code',
        message: 'Failed to set language code',
      );
    }
  }
}
