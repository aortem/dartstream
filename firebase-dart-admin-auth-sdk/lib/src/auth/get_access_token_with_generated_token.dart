import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';

abstract class GetAccessTokenWithGeneratedToken {
  static Future<String> getAccessTokenWithGeneratedToken(String jwt) async {
    try {
      http.Client client = http.Client();
      final response = await client.post(
        Uri.parse('https://oauth2.googleapis.com/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
          'assertion': jwt,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        return responseData['access_token']; // Return the access token
      } else {
        throw Exception('Failed to obtain access token');
      }
    } catch (e) {
      throw FirebaseAuthException(
        code: 'get-access-token-with-generated-token-failed',
        message: 'Failed to get access token with generated token',
      );
    }
  }
}
