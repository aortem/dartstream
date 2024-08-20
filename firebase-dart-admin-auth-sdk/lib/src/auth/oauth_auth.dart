import 'dart:async';
import 'package:firebase_dart_admin_auth_sdk/src/auth/auth_base.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth_provider.dart';
import 'package:firebase_dart_admin_auth_sdk/src/popup_redirect_resolver.dart';

class OAuthAuth extends AuthBase {
  OAuthAuth(super.auth);

  Future<UserCredential> signInWithPopup(
    AuthProvider provider, {
    PopupRedirectResolver? resolver,
  }) async {
    resolver ??= PopupRedirectResolver();

    final authUrl = await _getAuthUrl(provider);
    final result = await resolver.resolvePopup(authUrl);

    if (result.containsKey('error')) {
      throw FirebaseAuthException(
        code: result['error']['code'],
        message: result['error']['message'],
      );
    }

    final response = await auth.performRequest('signInWithIdp', {
      'providerId': provider.providerId,
      'signInMethod': 'popup',
      'idToken': result['idToken'],
      'accessToken': result['accessToken'],
    });

    final userCredential = UserCredential.fromJson(response.body);
    auth.updateCurrentUser(userCredential.user);
    return userCredential;
  }

  Future<String> _getAuthUrl(AuthProvider provider) async {
    final response = await auth.performRequest('getAuthUrl', {
      'providerId': provider.providerId,
      'continueUri':
          'http://localhost:5000', // Replace with your actual callback URL
    });

    return response.body['authUrl'];
  }
}
