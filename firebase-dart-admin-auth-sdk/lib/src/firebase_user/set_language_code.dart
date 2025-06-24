import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import '../../firebase_dart_admin_auth_sdk.dart';

/// A service class for managing a user's language preferences in Firestore.
///
/// This class provides functionality for setting and retrieving a user's language preference from Firestore.
/// The language preference is stored as part of the user's document in the Firestore database.
///
/// The class relies on Firebase Authentication for authenticating requests, using a Firebase token to perform
/// authorized updates to the user's language preference stored in Firestore.
///
/// This service class is primarily used for managing the user's language setting across the app.

class LanguageService {
  /// FirebaseAuth instance used to interact with Firebase Authentication services.
  final FirebaseAuth auth;

  /// Constructor that initializes the [LanguageService] with the required [FirebaseAuth] instance.
  ///
  /// - [auth]: The FirebaseAuth instance used to authenticate requests.
  LanguageService({required this.auth});

  /// Sets the language preference for a specific user in the Firestore database.
  ///
  /// This method updates the user's language preference stored in Firestore by sending a PATCH request to the
  /// Firestore API. The request is authenticated using the provided [tokenId], and the [languageCode] is updated
  /// in the user's Firestore document. The operation is performed within the specified [databaseName] in Firestore.
  ///
  /// - [userId]: The unique identifier of the user whose language preference is to be updated.
  /// - [tokenId]: The Firebase Authentication token used for authenticating the request.
  /// - [languageCode]: The language code (e.g., 'en', 'es', 'fr') that represents the user's preferred language.
  /// - [databaseName]: The name of the Firestore database where the user's document resides.
  ///
  /// Returns a [Future<void>] indicating the completion of the operation. If successful, the language preference
  /// is updated; otherwise, an error message is logged.

  Future<String?> setLanguagePreference(
    String userId,
    String tokenId,
    String languageCode,
    String databaseName,
  ) async {
    try {
      // Construct the URL to update the user's document in Firestore
      final url =
          'https://firestore.googleapis.com/v1/projects/${auth.projectId}/databases/$databaseName/documents/users/$userId';
      // Prepare the body of the request with the new language code
      final body = jsonEncode({
        "fields": {
          "languageCode": {"stringValue": languageCode},
        },
      });
      // Send a PATCH request to Firestore with the necessary headers and body
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenId', // Bearer token for authentication
        },
        body: body,
      );
      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        return 'Language preference set successfully.';
      } else {
        return response.body;
      }
    } catch (e) {
      // Handle and log any errors that occur during the request
      return "Error: $e";
    }
  }
}
