import 'package:ds_standard_features/ds_standard_features.dart' as http;
import '../../firebase_dart_admin_auth_sdk.dart';
import 'dart:convert';

/// A service that performs actions before an authentication state change in Firebase.
///
/// This service intercepts the authentication state before it's changed, allows for custom actions to be performed,
/// and then makes an HTTP request to the Firebase Authentication REST API to refresh the authentication token.
///
/// It is useful for performing additional actions such as logging, invalidating sessions, or preparing for the authentication
/// state change before it actually occurs.
class FirebaseBeforeAuthStateChangeService {
  /// The [FirebaseAuth] instance used for authentication operations.
  final FirebaseAuth auth;

  /// Constructs an instance of [FirebaseBeforeAuthStateChangeService].
  ///
  /// Parameters:
  /// - [auth]: The [FirebaseAuth] instance that provides authentication functionality.
  FirebaseBeforeAuthStateChangeService(this.auth);

  /// Executes actions before changing the authentication state, and then
  /// refreshes the authentication token.
  ///
  /// This method performs the following steps:
  /// 1. Logs the current authentication state.
  /// 2. Executes a custom action before changing the authentication state.
  /// 3. Makes an HTTP request to Firebase Authentication REST API to refresh the authentication token.
  /// 4. Handles the response by logging success or failure.
  ///
  /// Parameters:
  /// - [authToken]: The current authentication token.
  /// - [refreshToken]: The refresh token used to obtain a new authentication token.
  ///
  /// Throws a [FirebaseAuthException] if any step in the process fails.
  Future<void> beforeAuthStateChange(
    String authToken,
    String refreshToken,
  ) async {
    try {
      // Step 1: Intercept or log the current authentication state (before changing it)
      print("Intercepting current auth state...");

      // Step 2: Perform any necessary custom action before changing the auth state
      await _performBeforeAuthAction(authToken);

      // Step 3: Make an HTTP request to Firebase Authentication REST API to refresh the auth token
      final response = await _refreshAuthToken(authToken, refreshToken);

      // Step 4: Handle the response
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print("Auth state changed successfully.");
        print("New Token: ${responseBody['id_token']}");
      } else {
        final responseBody = json.decode(response.body);
        print(
          "Failed to change auth state: ${responseBody['error']['message']}",
        );
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
  /// This method can be customized to perform various actions before changing the authentication state,
  /// such as invalidating sessions, logging out the user, or other custom operations.
  ///
  /// Parameters:
  /// - [authToken]: The current authentication token.
  Future<void> _performBeforeAuthAction(String authToken) async {
    // Custom logic before changing the auth state
    // For example, invalidate the session, log out the user, etc.
    print("Performing action before auth state change...");
    // Simulating a delay for the custom action (this can be replaced with actual business logic)
    await Future.delayed(Duration(seconds: 2));
  }

  /// Refreshes the authentication token using the Firebase Authentication REST API.
  ///
  /// This method sends a request to the Firebase Authentication service to exchange the provided refresh token
  /// for a new authentication token.
  ///
  /// Parameters:
  /// - [authToken]: The current authentication token (this is unused in the request but could be included for tracking).
  /// - [refreshToken]: The refresh token to obtain a new auth token.
  ///
  /// Returns a [Future] that resolves to an [http.Response] containing the response from Firebase's API.
  ///
  /// Throws an exception if the HTTP request fails.
  Future<http.Response> _refreshAuthToken(
    String authToken,
    String refreshToken,
  ) async {
    String url = 'https://identitytoolkit.googleapis.com/v1/token';

    url = '$url?key=${auth.apiKey}';

    // Making the HTTP request to Firebase Authentication to refresh the token
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "grant_type": "refresh_token",
        "refresh_token": refreshToken,
      }),
    );

    return response;
  }
}
