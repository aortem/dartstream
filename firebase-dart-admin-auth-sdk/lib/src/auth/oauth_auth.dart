import 'dart:async';
import 'package:firebase_dart_admin_auth_sdk/src/auth/auth_base.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth_provider.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/popup_redirect_resolver.dart';
import 'package:firebase_dart_admin_auth_sdk/src/http_response.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_app.dart';

class OAuthAuth extends AuthBase {
  OAuthAuth(super.auth);

  Future<UserCredential> signInWithPopup(
    AuthProvider provider, {
    PopupRedirectResolver? resolver,
  }) async {
    if (FirebaseApp.instance.getAuth() == null) {
      throw FirebaseAuthException(
        code: 'no-auth',
        message:
            'No FirebaseAuth instance is available. Make sure to call FirebaseApp.initializeApp() first.',
      );
    }

    resolver ??= PopupRedirectResolver();

    try {
      final authUrl = await _getAuthUrl(provider);
      final result = await resolver.resolvePopup(authUrl);

      if (result == null || result['error'] != null) {
        throw FirebaseAuthException(
          code: 'popup-closed-by-user',
          message: 'The popup was closed before authentication could complete.',
        );
      }

      final HttpResponse response = await auth.performRequest(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithIdp',
        {
          'key': auth.apiKey,
          'providerId': provider.providerId,
          'requestUri': result['redirectUrl'],
          'postBody':
              'id_token=${result['idToken']}&access_token=${result['accessToken']}',
        },
      );

      if (response.statusCode != 200) {
        throw FirebaseAuthException(
          code: 'sign-in-failed',
          message: 'Failed to sign in: ${response.body}',
        );
      }

      final userCredential = UserCredential.fromJson(response.body);
      auth.updateCurrentUser(userCredential.user);

      // Notify listeners about the auth state change
      auth.authStateChangedController.add(userCredential.user);
      auth.idTokenChangedController.add(userCredential.user);

      return userCredential;
    } catch (e) {
      if (e is FirebaseAuthException) {
        rethrow;
      }
      throw FirebaseAuthException(
        code: 'popup-sign-in-error',
        message: 'Failed to sign in with popup: ${e.toString()}',
      );
    }
  }

  Future<String> _getAuthUrl(AuthProvider provider) async {
    final HttpResponse response = await auth.performRequest(
      'https://identitytoolkit.googleapis.com/v1/accounts:getAuthUri',
      {
        'key': auth.apiKey,
        'providerId': provider.providerId,
        'continueUri': 'http://localhost', // Or your actual redirect URI
      },
    );

    if (response.statusCode != 200) {
      throw FirebaseAuthException(
        code: 'auth-uri-error',
        message: 'Failed to get auth URI: ${response.body}',
      );
    }

    return response.body['authUri'];
  }
}
