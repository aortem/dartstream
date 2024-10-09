import 'dart:async';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk/src/http_response.dart';
import '../popup_redirect_resolver.dart';

class OAuthAuth {
  final FirebaseAuth _auth;

  OAuthAuth(this._auth);

  Future<UserCredential> signInWithPopup(
    AuthProvider provider,
    String clientId,
  ) async {
    try {
      final authUrl = _getAuthUrl(provider, clientId);
      final popupResolver = PopupRedirectResolver();
      final result = await popupResolver.resolvePopup(authUrl);

      if (result == null) {
        throw FirebaseAuthException(
          code: 'popup-closed-by-user',
          message: 'Popup was closed by user before finalizing the operation.',
        );
      }

      final HttpResponse response = await _auth.performRequest(
        'signInWithIdp',
        {
          'providerId': provider.providerId,
          'requestUri': 'http://localhost:5000',
          'postBody':
              'id_token=${result['idToken']}&providerId=${provider.providerId}',
          'returnSecureToken': true,
        },
      );

      if (response.body is String &&
          (response.body as String).startsWith('<!DOCTYPE')) {
        throw FirebaseAuthException(
          code: 'invalid-response',
          message:
              'Received HTML instead of JSON. Server might be returning an error page.',
        );
      }

      return UserCredential.fromJson(response.body);
    } catch (e) {
      print('Detailed signInWithPopup error: $e');
      throw FirebaseAuthException(
        code: 'popup-sign-in-error',
        message: 'Failed to sign in with popup: ${e.toString()}',
      );
    }
  }

  String _getAuthUrl(AuthProvider provider, String clientId) {
    final redirectUri = 'http://localhost:5000';
    final authUri = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'response_type': 'token id_token',
      'scope': 'email profile',
      'nonce': DateTime.now().millisecondsSinceEpoch.toString(),
    });
    return authUri.toString();
  }
}
