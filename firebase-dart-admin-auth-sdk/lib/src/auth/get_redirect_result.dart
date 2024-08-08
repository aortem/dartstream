import 'dart:convert';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class GetRedirectResultService {
  final dynamic auth;

  GetRedirectResultService({required this.auth});

  Future<UserCredential?> getRedirectResult() async {
    try {
      final url = Uri.https(
        'identitytoolkit.googleapis.com',
        '/v1/accounts:signInWithIdp',
        {'key': auth.apiKey},
      );

      final response = await auth.httpClient.post(
        url,
        body: json.encode({
          'returnSecureToken': true,
          'returnIdpCredential': true,
        }),
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body)['error'];
        throw FirebaseAuthException(
          code: error['message'],
          message: error['message'],
        );
      }

      final data = json.decode(response.body);

      // If there's no user data, it means no redirect sign-in was performed
      if (!data.containsKey('localId')) {
        return null;
      }

      // Create and return a UserCredential object
      return UserCredential(
        user: User(
          uid: data['localId'],
          email: data['email'],
          displayName: data['displayName'],
          // Add other user properties as needed
        ),
        // Add additional credential information if available
      );
    } catch (e) {
      throw FirebaseAuthException(
        code: 'get-redirect-result-error',
        message: 'Failed to get redirect result: ${e.toString()}',
      );
    }
  }
}
