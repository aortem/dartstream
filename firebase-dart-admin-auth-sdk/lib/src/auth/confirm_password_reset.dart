import 'dart:convert';
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';

///confirmpassword service
class ConfirmPasswordResetService {
  ///firebase auth instance
  final dynamic auth;

  ///confirmpassword service
  ConfirmPasswordResetService({required this.auth});

  ///confirm password function
  Future<void> confirmPasswordReset(String oobCode, String newPassword) async {
    try {
      final url = Uri.https(
        'identitytoolkit.googleapis.com',
        '/v1/accounts:resetPassword',
        {if (auth.apiKey != 'your_api_key') 'key': auth.apiKey},
      );

      final response = await auth.httpClient.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (auth.accessToken != null)
            'Authorization': 'Bearer ${auth.accessToken}',
        },
        body: json.encode({'oobCode': oobCode, 'newPassword': newPassword}),
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body)['error'];
        throw FirebaseAuthException(
          code: error['message'],
          message: error['message'],
        );
      }
    } catch (e) {
      throw FirebaseAuthException(
        code: 'confirm-password-reset-error',
        message: 'Failed to confirm password reset: ${e.toString()}',
      );
    }
  }
}
