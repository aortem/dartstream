import '../../firebase_dart_admin_auth_sdk.dart';

/// A service that handles the sign-out process for the current user in Firebase Authentication.
///
/// This class is responsible for signing out the current user from Firebase, effectively
/// clearing any authentication state and user-related data in the app.
class FirebaseSignOut {
  /// Signs out the current user and clears their session.
  ///
  /// This method performs the following actions:
  /// 1. Sets the current user to `null` using [FirebaseApp.instance.setCurrentUser],
  ///    effectively logging the user out and clearing their session.
  ///
  /// This method does not return any value.
  ///
  /// Throws:
  /// - No exceptions are thrown by this method.
  Future<void> signOut() async {
    // Clear the current user session by setting the current user to null.
    FirebaseApp.instance.setCurrentUser(null);
  }
}
