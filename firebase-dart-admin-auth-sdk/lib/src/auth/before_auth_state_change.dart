import 'package:ds_standard_features/ds_standard_features.dart' as http;
import '../../firebase_dart_admin_auth_sdk.dart';
import 'dart:convert';

/// A service that performs actions before an authentication state change in Firebase.
///
/// This service allows you to intercept, log, and perform custom actions before
/// updating the authentication state. It then makes an HTTP request to the
/// Firebase Authentication REST API to refresh the authentication token.
class FirebaseBeforeAuthStateChangeService {
  /// The [FirebaseAuth] instance used for authentication operations.
  final FirebaseAuth auth;

  /// Constructs an instance of [FirebaseBeforeAuthStateChangeService].
  ///
  /// Parameters:
  /// - [auth]: The [FirebaseAuth] instance for authentication operations.
  FirebaseBeforeAuthStateChangeService(this.auth);

  /// Executes actions before changing the authentication state, and then
  /// refreshes the authentication token.
  ///
  /// Parameters:
  /// - [authToken]: The current authentication token.
  /// - [refreshTtoken]: The refresh token used to obtain a new auth token.
  ///
  /// This method performs the following steps:
  /// 1. Logs the current authentication state.
  /// 2. Executes a custom action before changing the auth state.
  /// 3. Makes an HTTP request to refresh the auth token.
  /// 4. Handles the response by logging success or failure.
  ///
  /// Throws a [FirebaseAuthException] if the operation fails.
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
        message: 'Failed to change authentication state before update.',
      );
    }
  }

  /// Performs a custom action before the authentication state change.
  ///
  /// Parameters:
  /// - [authToken]: The current authentication token.
  ///
  /// This method can be customized to perform various actions, such as
  /// invalidating sessions or logging out the user.
  Future<void> _performBeforeAuthAction(String authToken) async {
    print("Performing action before auth state change...");
    await Future.delayed(Duration(seconds: 2));
  }

  /// Refreshes the authentication token using the Firebase Authentication REST API.
  ///
  /// Parameters:
  /// - [authToken]: The current authentication token (unused here).
  /// - [refreshTtoken]: The refresh token to obtain a new auth token.
  ///
  /// Returns a [Future] that resolves to an [http.Response] from the server.
  ///
  /// Throws an exception if the HTTP request fails.
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
