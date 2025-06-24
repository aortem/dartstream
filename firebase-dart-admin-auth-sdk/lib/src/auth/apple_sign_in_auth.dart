import 'dart:convert';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

///apple auth
class AppleSignInAuth {
  ///auth
  final FirebaseAuth auth;

  ///apple auth
  AppleSignInAuth(this.auth);

  ///sign in apple
  Future<UserCredential> signInWithApple(
    String idToken, {
    String? nonce,
  }) async {
    try {
      final url = Uri.https(
        'identitytoolkit.googleapis.com',
        '/v1/accounts:signInWithIdp',
        {if (auth.apiKey != 'your_api_key') 'key': auth.apiKey},
      );

      final requestBody = {
        'postBody': 'id_token=$idToken&providerId=apple.com',
        'requestUri': 'http://localhost',
        'returnSecureToken': true,
        'returnIdpCredential': true,
      };

      if (nonce != null) {
        requestBody['nonce'] = nonce;
      }

      final response = await auth.httpClient.post(
        url,
        body: json.encode(requestBody),
        headers: {
          'Content-Type': 'application/json',
          if (auth.accessToken != null)
            'Authorization': 'Bearer ${auth.accessToken}',
        },
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body)['error'];
        throw FirebaseAuthException(
          code: error['message'] ?? 'apple-sign-in-failed',
          message: error['message'] ?? 'Failed to sign in with Apple',
        );
      }

      final data = json.decode(response.body);
      final user = User(
        uid: data['localId'],
        email: data['email'],
        displayName: data['displayName'],
        photoURL: data['photoUrl'],
        emailVerified: data['emailVerified'] ?? false,
        idToken: data['idToken'],
        refreshToken: data['refreshToken'],
      );

      auth.updateCurrentUser(user);
      return UserCredential(user: user, providerId: 'apple.com');
    } catch (e) {
      throw FirebaseAuthException(
        code: 'apple-sign-in-error',
        message: 'Failed to sign in with Apple: ${e.toString()}',
      );
    }
  }
}
