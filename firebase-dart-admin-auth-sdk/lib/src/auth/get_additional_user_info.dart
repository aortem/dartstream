import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user.dart';

/// Service to fetch additional user information from Firebase Authentication.
///
/// This class handles the process of retrieving detailed user information using
/// an ID token. The user information is then used to update the current user
/// within the FirebaseAuth instance.
class GetAdditionalUserInfo {
  /// [auth] The instance of FirebaseAuth used to perform authentication actions.
  final FirebaseAuth auth;

  /// Constructor to initialize the [GetAdditionalUserInfo] service.
  GetAdditionalUserInfo({required this.auth});

  /// Retrieves additional user information from Firebase Authentication.
  ///
  /// This method sends a request to Firebase to fetch the user's information
  /// associated with the provided ID token. The user information is then
  /// used to update the current user in the FirebaseAuth instance.
  ///
  /// Parameters:
  /// - [idToken]: The ID token of the authenticated user whose information is
  ///   to be retrieved.
  ///
  /// Returns:
  /// - A [Future] that resolves to a [User] object containing the user's
  ///   details.
  ///
  /// Throws:
  /// - [FirebaseAuthException] if there is an error while retrieving user
  ///   information or if the provided ID token is invalid.
  Future<User> getAdditionalUserInfo(String? idToken) async {
    try {
      assert(
        idToken != null,
        'Id token cannot be null',
      ); // Ensure idToken is not null

      // Request additional user information from Firebase
      final response = await auth.performRequest('lookup', {
        "idToken": idToken,
      });

      // Parse the response body and create a User object from the data
      User user = User.fromJson((response.body['users'] as List)[0]);

      // Update the current user in the FirebaseAuth instance
      auth.updateCurrentUser(user);

      // Return the user object containing the retrieved information
      return user;
    } catch (e) {
      // Handle errors and throw a FirebaseAuthException
      print('Get additional user info failed: $e');
      throw FirebaseAuthException(
        code: 'get-additonal-user-info',
        message: 'Failed to get additional user info',
      );
    }
  }
}
