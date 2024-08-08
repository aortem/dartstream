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
      final errorData = json.decode(response.body);
      throw FirebaseAuthException(
        code: errorData['error']['message'],
        message: 'Failed to create new user: ${errorData['error']['message']}',
      );
    }

    final responseData = json.decode(response.body);
    final user = User.fromJson(responseData);
    return UserCredential(user: user);
  }
}
