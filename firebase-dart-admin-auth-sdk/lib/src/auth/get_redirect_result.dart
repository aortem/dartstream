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
      body: json.encode({
        'idToken': await auth.currentUser?.getIdToken(),
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 400) {
        // No redirect result available
        return null;
      }
      throw FirebaseAuthException(
        code: 'get-redirect-result-failed',
        message: 'Failed to get redirect result: ${response.body}',
      );
    }

    final responseData = json.decode(response.body);
    final userData = responseData['users'][0];

    return UserCredential(
      user: User(
        uid: userData['localId'],
        email: userData['email'],
        displayName: userData['displayName'],
        // Add other user properties as needed
      ),
      // Add other credential properties as needed
    );
  }
}
