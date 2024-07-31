import 'dart:convert';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class CreateUserWithEmailAndPasswordService {
  final FirebaseAuth auth;

  CreateUserWithEmailAndPasswordService(this.auth);

  Future<UserCredential> create(String email, String password) async {
    final url = Uri.https(
      'identitytoolkit.googleapis.com',
      '/v1/accounts:signUp',
      {'key': auth.apiKey},
    );

    final response = await auth.httpClient.post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw FirebaseAuthException(
        code: 'create-user-failed',
        message: 'Failed to create new user: ${response.body}',
      );
    }

    final responseData = json.decode(response.body);

    return UserCredential(
      user: User(
        uid: responseData['localId'],
        email: responseData['email'],
        emailVerified: false,
        // isAnonymous: false,
      ),
      // Add other credential properties as needed
    );
  }
}
