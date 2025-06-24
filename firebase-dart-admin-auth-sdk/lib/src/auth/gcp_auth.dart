import 'dart:convert';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

///gcpAuth
class GCPAuth {
  ///gcpAuth
  final FirebaseAuth auth;

  ///gcpauth
  GCPAuth(this.auth);

  ///sign in with gcp
  Future<UserCredential> signInWithGCP({
    required String clientId,
    required String clientSecret,
  }) async {
    try {
      if (auth.serviceAccount == null) {
        throw FirebaseAuthException(
          code: 'no-service-account',
          message:
              'Service account configuration is required for GCP authentication',
        );
      }

      // First get OAuth token using client credentials
      final tokenUrl = Uri.https('oauth2.googleapis.com', '/token');

      final tokenResponse = await auth.httpClient.post(
        tokenUrl,
        body: {
          'grant_type': 'client_credentials',
          'client_id': clientId,
          'client_secret': clientSecret,
          'scope': 'https://www.googleapis.com/auth/cloud-platform',
        },
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      if (tokenResponse.statusCode != 200) {
        throw FirebaseAuthException(
          code: 'gcp-oauth-failed',
          message: 'Failed to obtain GCP OAuth token',
        );
      }

      final tokenData = json.decode(tokenResponse.body);
      final accessToken = tokenData['access_token'];

      // Now use the access token to sign in with Firebase
      final url = Uri.https(
        'identitytoolkit.googleapis.com',
        '/v1/accounts:signInWithIdp',
        {if (auth.apiKey != 'your_api_key') 'key': auth.apiKey},
      );

      final response = await auth.httpClient.post(
        url,
        body: json.encode({
          'postBody': 'access_token=$accessToken&providerId=oidc.gcp',
          'requestUri': 'http://localhost',
          'returnSecureToken': true,
          'returnIdpCredential': true,
        }),
        headers: {
          'Content-Type': 'application/json',
          if (auth.accessToken != null)
            'Authorization': 'Bearer ${auth.accessToken}',
        },
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body)['error'];
        throw FirebaseAuthException(
          code: error['message'] ?? 'gcp-sign-in-failed',
          message: error['message'] ?? 'Failed to sign in with GCP',
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
      return UserCredential(user: user, providerId: 'oidc.gcp');
    } catch (e) {
      throw FirebaseAuthException(
        code: 'gcp-sign-in-error',
        message: 'Failed to sign in with GCP: ${e.toString()}',
      );
    }
  }
}
