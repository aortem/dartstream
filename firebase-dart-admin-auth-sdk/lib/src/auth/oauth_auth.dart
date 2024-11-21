import 'dart:async';
import 'dart:developer';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'dart:convert';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

///OAuth
class OAuthAuth {
  final FirebaseAuth _auth;

  ///OAuth
  OAuthAuth(this._auth);

  ///sign in with pop up
  Future<UserCredential> signInWithPopup(
    AuthProvider provider,
    String accessToken,
  ) async {
    try {
      log("Access Token: $accessToken");
      log("Provider ID: ${provider.providerId}");

      final url =
          'https://identitytoolkit.googleapis.com/v1/accounts:signInWithIdp?key=${_auth.apiKey}';

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'postBody':
              'access_token=$accessToken&providerId=${provider.providerId}',
          'requestUri': 'http://localhost:5000',
          'returnSecureToken': true,
        }),
      );

      log('Popup sign-in response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final userCredential = UserCredential.fromJson(responseData);

        _auth.updateCurrentUser(userCredential.user);
        FirebaseApp.instance.setCurrentUser(userCredential.user);

        log("Signed in user: ${userCredential.user.email}");
        return userCredential;
      } else {
        log('Failed to sign in with popup: ${response.statusCode}');
        log('Error response: ${response.body}');
        throw FirebaseAuthException(
          code: 'popup-sign-in-error',
          message: 'Failed to sign in with popup: ${response.body}',
        );
      }
    } catch (error) {
      log('Error during popup sign in: $error');
      throw FirebaseAuthException(
        code: 'popup-sign-in-error',
        message: error.toString(),
      );
    }
  }
}
