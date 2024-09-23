import 'package:firebase_dart_admin_auth_sdk/src/http_response.dart';

import '../../firebase_dart_admin_auth_sdk.dart';


class FirebaseUserGetIdTokenResult {
  final FirebaseAuth auth;

  FirebaseUserGetIdTokenResult({required this.auth});

  Future<HttpResponse>  getIdTokenResult(bool forceRefresh) async {
    try {
      final url = 'idToken';
      final body = {
        'idToken': await auth.currentUser!.getIdToken(forceRefresh),
      };
      return await auth.performRequest(url, body);
    } catch (e) {
      print('Get ID token result failed: $e');
      throw FirebaseAuthException(
        code: 'get-id-token-result-error',
        message: 'Failed to get ID token result.',
      );
    }
  }
}
