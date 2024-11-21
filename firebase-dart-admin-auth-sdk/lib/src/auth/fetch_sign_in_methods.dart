import 'dart:convert';
import '../exceptions.dart';

///fetchsignin
class FetchSignInMethodsService {
  ///auth
  final dynamic auth;

  ///fetch signin
  FetchSignInMethodsService({required this.auth});

  ///fetch sign in methods
  Future<List<String>> fetchSignInMethodsForEmail(String email) async {
    try {
      final url = Uri.https(
        'identitytoolkit.googleapis.com',
        '/v1/accounts:createAuthUri',
        {'key': auth.apiKey},
      );

      final response = await auth.httpClient.post(
        url,
        body: json.encode({
          'identifier': email,
          'continueUri': 'http://localhost',
        }),
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body)['error'];
        throw FirebaseAuthException(
          code: error['message'],
          message: error['message'],
        );
      }

      final data = json.decode(response.body);
      List<String> methods =
          (data['signinMethods'] as List<dynamic>?)?.cast<String>() ?? [];
      return methods;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'fetch-sign-in-methods-error',
        message: 'Failed to fetch sign-in methods: ${e.toString()}',
      );
    }
  }
}
