import 'package:ds_standard_features/ds_standard_features.dart' as http;
import '../../firebase_dart_admin_auth_sdk.dart';
import 'dart:convert';

class FirebaseBeforeAuthStateChangeService {
  final FirebaseAuth auth;

  FirebaseBeforeAuthStateChangeService(this.auth);

  Future<void> beforeAuthStateChange(
      String authToken, String refreshTtoken) async {
    try {
      // Step 1: Intercept or log the current auth state (before changing it)
      print("Intercepting current auth state...");

      // Step 2: Perform the necessary action before changing the auth state
      await _performBeforeAuthAction(authToken);

      // Step 3: Make the HTTP request to Firebase Authentication REST API
      final response = await _refreshAuthToken(authToken, refreshTtoken);

      // Step 4: Handle the response
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print("Auth state changed successfully.");
        print("New Token: ${responseBody['id_token']}");
      } else {
        final responseBody = json.decode(response.body);
        print(
            "Failed to change auth state: ${responseBody['error']['message']}");
      }
    } catch (e) {
      print('Failed Before Auth State Changed: $e');
      throw FirebaseAuthException(
        code: 'before-auth-state-changed-error',
        message: 'Failed to Before Auth State Changed.',
      );
    }
  }

  Future<void> _performBeforeAuthAction(String authToken) async {
    // Custom logic before changing the auth state
    // For example, invalidate the session, log out the user, etc.
    print("Performing action before auth state change...");
    await Future.delayed(Duration(seconds: 2));
  }

  Future<http.Response> _refreshAuthToken(
      String authToken, String refreshTtoken) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/token?key=${auth.apiKey}';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "grant_type": "refresh_token",
        "refresh_token": refreshTtoken,
      }),
    );

    return response;
  }
}
