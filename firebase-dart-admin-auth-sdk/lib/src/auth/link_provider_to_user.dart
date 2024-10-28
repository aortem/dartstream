import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';

class LinkProviderToUser {
  final FirebaseAuth auth;

  LinkProviderToUser({required this.auth});

  Future<bool> linkProviderToUser(
    String? idToken,
    String providerId,
    String providerIdToken,
  ) async {
    try {
      assert(idToken != null, 'Id token cannot be null');
      assert(providerId.isNotEmpty, 'Provide Id cannot be empty');
      assert(providerIdToken.isNotEmpty, 'Provide Id Token cannot be empty');
      await auth.performRequest(
        'update',
        {
          "idToken": idToken,
          "providerId": providerId,
          "postBody": 'id_token=$providerIdToken&providerId=$providerId',
          "returnSecureToken": true,
        },
      );
      return true;
    } catch (e) {
      print('Link additional provider to user failed: $e');
      throw FirebaseAuthException(
        code: 'link-additonal-provider',
        message: 'Failed to link additonal provider',
      );
    }
  }
}
