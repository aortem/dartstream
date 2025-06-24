import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/http_response.dart';

import '../exceptions.dart';

/// A utility class for parsing action code URLs for Firebase authentication.
///
/// This class provides a method to send a request to Firebase Authentication's
/// backend service to parse an action code URL, which is typically used in email
/// action links (e.g., password reset, email verification, etc.).
///
/// The `parseActionCodeURL` method accepts an `oobCode` (out-of-band code) which
/// is included in action link URLs sent by Firebase to the user. It communicates with
/// Firebase backend to extract relevant information from the action code URL.
class FirebaseParseUrlLink {
  /// Firebase Authentication instance used for interacting with Firebase Authentication.
  final FirebaseAuth auth;

  /// Constructor for [FirebaseParseUrlLink] class.
  ///
  /// Takes a [FirebaseAuth] instance that is used to interact with Firebase Authentication.
  ///
  /// - [auth]: An instance of [FirebaseAuth] that handles communication with the Firebase Authentication service.
  FirebaseParseUrlLink({required this.auth});

  /// Parses an action code URL provided by Firebase Authentication.
  ///
  /// The provided `oobCode` is the out-of-band code (a unique identifier) that is typically found
  /// in action link URLs sent to users for various authentication-related actions like email
  /// verification or password reset.
  ///
  /// This method sends a request to Firebase's backend to parse the action code URL and return
  /// relevant information associated with that code.
  ///
  /// Returns an [HttpResponse] containing the parsed details of the action code URL.
  ///
  /// Throws [FirebaseAuthException] if there is an error during the request process.
  Future<HttpResponse> parseActionCodeURL(String oobCode) async {
    try {
      // URL endpoint for parsing action code
      final url = 'parseCode';

      // Request body containing the oobCode
      final body = {'oobCode': oobCode};

      // Send the request to Firebase Authentication's backend service
      final response = await auth.performRequest(url, body);

      return response; // Returning the response, which should contain parsed URL details
    } catch (e) {
      print('Parse action code URL failed: $e');
      throw FirebaseAuthException(
        code: 'parse-action-code-url-error',
        message: 'Failed to parse action code URL.',
      );
    }
  }
}
