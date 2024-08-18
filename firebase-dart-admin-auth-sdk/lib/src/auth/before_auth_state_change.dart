import 'package:firebase_dart_admin_auth_sdk/src/http_response.dart';

import '../../firebase_dart_admin_auth_sdk.dart';

class FirebaseBeforeAuthStateChangeService {
  final FirebaseAuth auth;

  FirebaseBeforeAuthStateChangeService(
    this.auth,
  );

  Future<void> beforeAuthStateChange(String authToken) async {
    // Step 1: Intercept or log the current auth state (before changing it)
    print("Intercepting current auth state...");

    // Step 2: Perform the necessary action before changing the auth state
    // Example: Log out the user, expire the token, etc.
    await _performBeforeAuthAction(authToken);

    // Step 3: Make the HTTP request to Firebase Authentication REST API
    // Example: Refresh the auth token (changing auth state)
    final response = await _refreshAuthToken(authToken);

    // Step 4: Handle the response
    if (response.statusCode == 200) {
      print("Auth state changed successfully.");

      print("New Token: ${response.body['idToken']}");
    } else {
      print("Failed to change auth state: ${response.body}");
    }
  }

  Future<void> _performBeforeAuthAction(String authToken) async {
    // Custom logic before changing the auth state
    // For example, invalidate the session, log out the user, etc.
    print("Performing action before auth state change...");
    await Future.delayed(Duration(seconds: 2));
  }

  Future<HttpResponse> _refreshAuthToken(String authToken) async {
    final response = await auth.performRequest(
      'signInWithPassword',
      {
        "idToken": authToken,
        "returnSecureToken": true,
      },
    );
    return response;
    // Make a request to the Firebase Authentication REST API to refresh the token
    // This is just an example; in practice, you may want to use other endpoints or actions.
  }
}
