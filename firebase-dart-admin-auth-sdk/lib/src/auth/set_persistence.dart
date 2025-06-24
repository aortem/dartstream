import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import '../../firebase_dart_admin_auth_sdk.dart';

/// A service that manages the persistence setting for Firebase users.
///
/// This class allows you to set the persistence type for a user in a Firestore document.
/// The persistence type defines how the user's session or authentication state should
/// be persisted across app sessions (e.g., session-based or persistent).
///
/// The persistence setting can be used to control whether the user remains authenticated
/// between app sessions or if the authentication state should only last for the duration
/// of the session (e.g., until the app is closed).
class PersistenceService {
  /// The [FirebaseAuth] instance used to interact with Firebase Authentication.
  ///
  /// This instance is required to interact with Firebase Authentication APIs
  /// and perform authenticated operations such as sending requests with the appropriate
  /// authorization token.
  final FirebaseAuth auth;

  /// Constructs an instance of [PersistenceService].
  ///
  /// Parameters:
  /// - [auth]: The [FirebaseAuth] instance used for authentication actions.
  PersistenceService({required this.auth});

  /// Sets the persistence type for the given user in Firestore.
  ///
  /// This method makes an HTTP request to Firestore to update the persistence field
  /// for the specified user document. The persistence type can be 'session' for session-based
  /// persistence or 'persistent' for persistence across app restarts.
  ///
  /// The persistence setting determines how long the user's session or authentication state
  /// will remain valid, affecting whether the user is required to re-authenticate on app restart.
  ///
  /// Parameters:
  /// - [userId]: The ID of the user whose persistence setting needs to be updated.
  /// - [tokenId]: The ID token used for authorization in Firestore. It authenticates the request
  ///   and grants access to update the user's document in Firestore.
  /// - [persistenceType]: The persistence type to set, which can be either:
  ///   - 'session' (session-based persistence, where the user must re-authenticate after the session ends).
  ///   - 'persistent' (long-term persistence across app restarts).
  /// - [databaseName]: The name of the Firestore database in which the user's document resides.
  ///
  /// Throws:
  /// - [FirebaseAuthException] if the request to update the persistence field in Firestore fails.
  Future<void> setPersistence(
    String userId,
    String tokenId,
    String persistenceType,
    String databaseName,
  ) async {
    try {
      // Construct the Firestore document URL using the provided databaseName
      final url =
          'https://firestore.googleapis.com/v1/projects/${auth.projectId}/databases/$databaseName/documents/users/$userId';

      // Prepare the request body with the persistence type
      final body = jsonEncode({
        "fields": {
          "persistence": {"stringValue": persistenceType},
        },
      });

      // Send the PATCH request to Firestore to update the persistence field for the user
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $tokenId', // Authorization header using the tokenId
        },
        body: body,
      );

      // Handle the response from Firestore
      if (response.statusCode == 200) {
        // Successfully updated persistence field for the user
        print('Persistence set to $persistenceType for user $userId');
      } else {
        // Log an error if the update request failed
        print(
          'Failed to set persistence: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      // Catch any errors and log detailed error information for debugging
      print('Error setting persistence for user $userId: $e');
    }
  }
}
