import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk/src/additional_user_info.dart';

class GetRedirectResultService {
  final FirebaseAuth _auth;

  GetRedirectResultService({required FirebaseAuth auth}) : _auth = auth;

  Future<UserCredential?> getRedirectResult() async {
    try {
      final url = Uri.https(
        'identitytoolkit.googleapis.com',
        '/v1/accounts:signInWithIdp',
        {'key': _auth.apiKey},
      );

      final response = await _auth.httpClient.post(
        url,
        body: json.encode({
          'requestUri':
              'http://localhost', // This should be dynamically set in a real-world scenario
          'returnIdpCredential': true,
          'returnSecureToken': true,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw FirebaseAuthException(
          code: 'get-redirect-result-error',
          message: 'Failed to get redirect result: ${response.body}',
        );
      }

      final data = json.decode(response.body);

      if (data['idToken'] == null) {
        // No redirect result available
        return null;
      }

      final user = User(
        uid: data['localId'],
        email: data['email'],
        displayName: data['displayName'],
        photoURL: data['photoUrl'],
        phoneNumber: data['phoneNumber'],
        refreshToken: data['refreshToken'],
        tenantId: data['tenantId'],
        idToken: data['idToken'],
      );

      final credential = OAuthCredential(
        providerId: data['providerId'] ?? '',
        signInMethod: 'redirect',
        accessToken: data['oauthAccessToken'],
        idToken: data['oauthIdToken'],
      );

      final userCredential = UserCredential(
        user: user,
        credential: credential,
        additionalUserInfo: AdditionalUserInfo(
          isNewUser: data['isNewUser'] ?? false,
          providerId: data['providerId'],
          profile: data['profile'],
        ),
        operationType: 'signIn',
      );

      // Update the current user in FirebaseAuth
      _auth.updateCurrentUser(user);

      return userCredential;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'get-redirect-result-error',
        message: 'Failed to get redirect result: ${e.toString()}',
      );
    }
  }
}
