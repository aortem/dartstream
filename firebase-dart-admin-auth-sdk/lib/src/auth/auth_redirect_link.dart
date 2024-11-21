// ignore_for_file: public_member_api_docs

import 'dart:developer';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'dart:convert';

import '../../firebase_dart_admin_auth_sdk.dart';

class SignInWithRedirectService {
  final FirebaseAuth auth;

  SignInWithRedirectService({required this.auth});

  Future<UserCredential?> signInWithRedirect(
      String redirectUri, String idToken, String providerId) async {
    try {
      log("ID Token: $idToken");
      log("Provider ID: $providerId");

      final url =
          'https://identitytoolkit.googleapis.com/v1/accounts:signInWithIdp?key=${auth.apiKey}';

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'postBody': 'access_token=$idToken&providerId=$providerId',
          'requestUri': redirectUri,
          'returnSecureToken': true,
        }),
      );
      log('responseData: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final userCredential = UserCredential.fromJson(responseData);
        auth.updateCurrentUser(userCredential.user);
        log("current user data ${userCredential.user.idToken}");
        FirebaseApp.instance.setCurrentUser(userCredential.user);

        return userCredential;
      } else {
        log('Failed to sign in: ${response.statusCode}');
        log('Response: ${response.body}');
        return null;
      }
    } catch (error) {
      log('Error occurred during sign in: $error');
    }
    return null;
  }
}
