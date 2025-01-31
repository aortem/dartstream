
  
import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

class FirebaseInitializer {
  static Future<void> initializeWithServiceAccountImpersonation({
    required String serviceAccountEmail,
  }) async {
    // Get the access token from metadata server
    final defaultTokenResponse = await http.get(
      Uri.parse('http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token'),
      headers: {'Metadata-Flavor': 'Google'},
    );

    if (defaultTokenResponse.statusCode != 200) {
      throw Exception('Failed to get default token: ${defaultTokenResponse.body}');
    }

    final defaultToken = jsonDecode(defaultTokenResponse.body)['access_token'];

    // Impersonate the service account
    final impersonateResponse = await http.post(
      Uri.parse('https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/$serviceAccountEmail:generateAccessToken'),
      headers: {
        'Authorization': 'Bearer $defaultToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'scope': ['https://www.googleapis.com/auth/cloud-platform'],
      }),
    );

    if (impersonateResponse.statusCode != 200) {
      throw Exception('Failed to impersonate service account: ${impersonateResponse.body}');
    }

    final impersonatedToken = jsonDecode(impersonateResponse.body)['accessToken'];

    // Initialize Firebase with the impersonated token
   
  }
}