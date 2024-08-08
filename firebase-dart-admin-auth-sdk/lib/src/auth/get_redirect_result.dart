import 'dart:convert';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class GetRedirectResultService {
  final FirebaseAuth auth;

  GetRedirectResultService(this.auth);

  Future<UserCredential?> getResult() async {
    final url = Uri.https(
      'identitytoolkit.googleapis.com',
      '/v1/accounts:lookup',
      {'key': auth.apiKey},
    );

    final response = await auth.httpClient.post(
      url,
      body: json.encode({'idToken': await auth.currentUser?.getIdToken()}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 400) {
        return null;
      }
      throw FirebaseAuthException(
        code: 'get-redirect-result-failed',
        message: 'Failed to get redirect result: ${response.body}',
      );
    }

    final responseData = json.decode(response.body);
    final userData = responseData['users'][0];

    final user = User.fromJson(userData);
    return UserCredential(user: user);
  }
}
