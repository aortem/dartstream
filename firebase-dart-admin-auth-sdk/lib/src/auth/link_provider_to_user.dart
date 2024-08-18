import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user.dart';

class LinkProviderToUser {
  final FirebaseAuth auth;

  LinkProviderToUser({required this.auth});

  Future<User> linkProviderToUser(
    String? idToken,
    String providerId,
    String providerIdToken,
  ) async {
    try {
      assert(idToken != null, 'Id token cannot be null');
      assert(providerId.isNotEmpty, 'Provide Id cannot be empty');
      assert(providerIdToken.isNotEmpty, 'Provide Id Token cannot be empty');
      final response = await auth.performRequest(
        'update',
        {
          "idToken": idToken,
          "providerId": providerId,
          "providerIdToken": providerIdToken,
          "returnSecureToken": true,
        },
      );
      User user = User.fromJson((response.body['users'] as List)[0]);
      auth.updateCurrentUser(user);
      return user;
    } catch (e) {
      print('Link additional provider to user failed: $e');
      throw FirebaseAuthException(
        code: 'link-additonal-provider',
        message: 'Failed to link additonal provider',
      );
    }
  }
}
