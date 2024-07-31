import 'dart:convert';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class FetchSignInMethodsForEmailService {
  final FirebaseAuth auth;

  FetchSignInMethodsForEmailService(this.auth);

  Future<List<String>> fetch(String email) async {
    final url = Uri.https(
      'identitytoolkit.googleapis.com',
      '/v1/accounts:createAuthUri',
      {'key': auth.apiKey},
    );

    final response = await auth.httpClient.post(
      url,
      body: json.encode({
        'identifier': email,
        'continueUri': 'http://localhost',
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw FirebaseAuthException(
        code: 'fetch-sign-in-methods-failed',
        message: 'Failed to fetch sign-in methods for email: ${response.body}',
      );
    }

    final responseData = json.decode(response.body);
    return List<String>.from(responseData['signinMethods'] ?? []);
  }
}
