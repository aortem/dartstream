import 'dart:developer';

import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class VerifyPasswordResetCodeService {
  final FirebaseAuth auth;

  VerifyPasswordResetCodeService({required this.auth});
  Future<String?> verifyPasswordResetCode(String code) async {
    try {
      final url = 'resetPassword';
      final body = {
        'oobCode': code,
      };

      final response = await auth.performRequest(url, body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = response.body;

        if (responseBody.containsKey('email')) {
          final email = responseBody['email'];
          log("Password reset email: $email");
          return email; // Return the email if present
        } else {
          log("No email found in response.");
          return null; // Email not found in response
        }
      } else {
        throw FirebaseAuthException(
          code: 'invalid-reset-code',
          message: 'Invalid password reset code.',
        );
      }
    } catch (e) {
      print('Verify password reset code failed: $e');
      throw FirebaseAuthException(
        code: 'verify-password-reset-code-error',
        message: 'Failed to verify password reset code.',
      );
    }
  }
}
