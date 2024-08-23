import 'dart:async';
import 'package:firebase_dart_admin_auth_sdk/src/auth/auth_base.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth_provider.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/popup_redirect_resolver.dart';
import 'package:firebase_dart_admin_auth_sdk/src/http_response.dart';

class OAuthAuth extends AuthBase {
  OAuthAuth(super.auth);

  Future<UserCredential> signInWithPopup(
    AuthProvider provider, {
    PopupRedirectResolver? resolver,
  }) async {
    resolver ??= PopupRedirectResolver();

    final authUrl = await _getAuthUrl(provider);
    final result = await resolver.resolvePopup(authUrl);

    if (result == null || result['error'] != null) {
      throw FirebaseAuthException(
        code: 'popup-closed-by-user',
        message: 'The popup was closed before authentication could complete.',
      );
    }

    final HttpResponse response = await auth.performRequest('signInWithIdp', {
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
    final HttpResponse response = await auth.performRequest('getAuthUri', {
      'providerId': provider.providerId,
      'continueUri': 'http://localhost',
    });

    return response.body['authUri'];
  }
}
