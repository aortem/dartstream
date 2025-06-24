import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/http_response.dart';

/// An abstract base class providing core authentication functionality.
///
/// This class serves as a foundation for classes that need to perform
/// authentication requests using Firebase.
abstract class AuthBase {
  /// The [FirebaseAuth] instance used to perform authentication requests.
  final FirebaseAuth auth;

  /// Constructs an instance of [AuthBase].
  ///
  /// Parameters:
  /// - [auth]: The [FirebaseAuth] instance that will handle requests.
  AuthBase(this.auth);

  /// Sends an authenticated request to Firebase using the specified [endpoint]
  /// and request [body].
  ///
  /// Parameters:
  /// - [endpoint]: The Firebase endpoint to interact with (e.g., 'update').
  /// - [body]: A `Map<String, dynamic>` containing the request payload.
  ///
  /// Returns a [Future] that resolves to an [HttpResponse] containing the
  /// server's response.
  ///
  /// Example usage:
  /// ```dart
  /// performRequest('update', {'oobCode': 'someCode'});
  /// ```
  Future<HttpResponse> performRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) {
    return auth.performRequest(endpoint, body);
  }
}
