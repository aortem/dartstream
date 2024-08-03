import 'dart:convert';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk/src/multi_factor_resolver.dart';

class GetMultiFactorResolverService {
  final FirebaseAuth auth;

  GetMultiFactorResolverService(this.auth);

  Future<MultiFactorResolver> resolve(AuthCredential credential) async {
    final url = Uri.https(
      'identitytoolkit.googleapis.com',
      '/v1/accounts:signInWithPhoneNumber',
      {'key': auth.apiKey},
    );

    final response = await auth.httpClient.post(
      url,
      body: json.encode({
        'idToken': await auth.currentUser?.getIdToken(),
        'providerId': credential.providerId,
        // Add other necessary credential data
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw FirebaseAuthException(
        code: 'multi-factor-resolution-failed',
        message: 'Failed to get multi-factor resolver: ${response.body}',
      );
    }

    final responseData = json.decode(response.body);

    return MultiFactorResolver(
      sessionId: responseData['sessionInfo'],
      hints: (responseData['mfaInfo'] as List?)
              ?.map((hint) => MultiFactorHint(
                    factorId: hint['mfaEnrollmentId'],
                    displayName: hint['displayName'],
                  ))
              .toList() ??
          [],
    );
  }
}
