import 'dart:convert';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

///create user connect
class CreateUserWithEmailAndPasswordService {
  ///auth
  final FirebaseAuth auth;

  ///create user service
  CreateUserWithEmailAndPasswordService(this.auth);

  ///create function
  Future<UserCredential> create(String email, String password) async {
    final url = Uri.https(
      'identitytoolkit.googleapis.com',
      '/v1/accounts:signUp',
      {if (auth.apiKey != 'your_api_key') 'key': auth.apiKey},
    );
    final response = await auth.httpClient.post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
      headers: {
        'Content-Type': 'application/json',
        if (auth.accessToken != null)
          'Authorization': 'Bearer ${auth.accessToken}',
      },
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

    final additionalUserInfo = AdditionalUserInfo(
      isNewUser: true,
      providerId: 'password',
      profile: null,
    );

    final credential = EmailAuthCredential(email: email, password: password);

    return UserCredential(
      user: user,
      additionalUserInfo: additionalUserInfo,
      credential: credential,
    );
  }
}
