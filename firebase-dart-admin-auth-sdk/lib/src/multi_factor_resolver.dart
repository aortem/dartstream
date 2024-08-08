import 'dart:convert';
import 'package:firebase_dart_admin_auth_sdk/src/auth_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

class MultiFactorResolver {
  final String sessionId;
  final List<MultiFactorHint> hints;
  final FirebaseAuth auth;

  MultiFactorResolver({
    required this.sessionId,
    required this.hints,
    required this.auth,
  });

  Future<UserCredential> resolveSignIn(AuthCredential credential) async {
    final url = Uri.https(
      'identitytoolkit.googleapis.com',
      '/v1/accounts:signIn',
      {'key': auth.apiKey},
    );

    final Map<String, dynamic> body = {
      'mfaPendingCredential': sessionId,
      'mfaEnrollmentId': credential.providerId,
    };

    if (credential is PhoneAuthCredential) {
      body['phoneSignInInfo'] = {
        'sessionInfo': credential.verificationId,
        'code': credential.smsCode,
      };
    } else if (credential is EmailAuthCredential) {
      body['email'] = credential.email;
      body['password'] = credential.password;
    } else {
      throw FirebaseAuthException(
        code: 'invalid-credential',
        message: 'Unsupported credential type for MFA resolution.',
      );
    }

    final response = await http.post(
      url,
      body: json.encode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return UserCredential.fromJson(responseData);
    } else {
      final errorData = json.decode(response.body);
      throw FirebaseAuthException(
        code: errorData['error']['message'] ?? 'unknown',
        message: 'Failed to resolve MFA: ${errorData['error']['message']}',
      );
    }
  }
}

class MultiFactorHint {
  final String factorId;
  final String displayName;

  MultiFactorHint({required this.factorId, required this.displayName});
}

class FirebaseAuthException implements Exception {
  final String code;
  final String message;

  FirebaseAuthException({required this.code, required this.message});

  @override
  String toString() => 'FirebaseAuthException: $code - $message';
}
