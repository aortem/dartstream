import 'dart:convert';
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';

class ConfirmPasswordResetService {
  final dynamic auth;

  ConfirmPasswordResetService({required this.auth});

  Future<void> confirmPasswordReset(String code, String newPassword) async {
    try {
      final url = Uri.https(
        'identitytoolkit.googleapis.com',
        '/v1/accounts:resetPassword',
        {'key': auth.apiKey},
      );

      final response = await auth.httpClient.post(
        url,
        body: json.encode({
          'oobCode': code,
          'newPassword': newPassword,
        }),
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
