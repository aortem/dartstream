import 'dart:convert';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

class GetMultiFactorResolverService {
  final FirebaseAuth auth;

  GetMultiFactorResolverService(this.auth);

  Future<MultiFactorResolver> resolve(EmailAuthCredential credential) async {
    final url = Uri.https(
      'identitytoolkit.googleapis.com',
      '/v1/accounts:signInWithPassword',
      {'key': auth.apiKey},
    );

    final response = await http.post(
      url,
      body: json.encode({
        'email': credential.email,
        'password': credential.password,
        'returnSecureToken': true,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      final errorData = json.decode(response.body);
      if (errorData['error']['message'] == 'MULTI_FACTOR_AUTH_REQUIRED') {
        final mfaInfo = errorData['mfaInfo'];
        final sessionInfo = errorData['mfaPendingCredential'];

        return MultiFactorResolver(
          sessionId: sessionInfo,
          hints: (mfaInfo as List?)
                  ?.map((hint) => MultiFactorHint(
                        factorId: hint['mfaEnrollmentId'],
                        displayName: hint['displayName'] ?? 'Unknown',
                      ))
                  .toList() ??
              [],
        );
      } else {
        throw FirebaseAuthException(
          code: 'sign-in-failed',
          message: 'Failed to sign in: ${response.body}',
        );
      }
    }

    throw FirebaseAuthException(
      code: 'unexpected-response',
      message: 'Unexpected response: MFA not required',
    );
  }
}
