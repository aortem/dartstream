import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import '../../firebase_dart_admin_auth_sdk.dart';

/// A service class for retrieving the language preference of a user from Firestore.
///
/// This service uses Firebase Firestore to fetch the user's language preference stored in the Firestore database.
/// It requires the Firebase Authentication token and the user ID to make an authenticated request to Firestore.
///
/// The following class provides the functionality to interact with Firestore and fetch the user's preferred language.
/// It relies on the FirebaseAuth instance to authenticate requests.
class LanguageGetService {
  /// FirebaseAuth instance used to interact with Firebase services and authenticate requests.

  final FirebaseAuth auth;

  /// Constructor that initializes the LanguageGetService with the FirebaseAuth instance.
  ///
  /// The constructor requires an instance of [FirebaseAuth] to authenticate the request and fetch the user's data
  /// from Firestore.
  ///
  /// - [auth]: The FirebaseAuth instance used for authentication.
  LanguageGetService({required this.auth});

  /// Retrieves the language preference of a specific user from Firestore.
  ///
  /// This method fetches the user's language preference by querying Firestore for the user's document
  /// and extracting the language code stored in the document. The request is authenticated using the provided
  /// [tokenId], and the [userId] identifies the user whose language preference is being retrieved.
  ///
  /// - [userId]: The unique identifier of the user whose language preference is to be fetched.
  /// - [tokenId]: The Firebase Authentication token that is used to authorize the request.
  /// - [databaseName]: The name of the Firestore database to query.
  ///
  /// Returns the language code (e.g., 'en', 'es') if successful, or null if the request fails or the language
  /// preference is not found.
  ///
  /// If the retrieval is unsuccessful, the error is logged, and the method returns null.

  Future<String?> getLanguagePreference(
    String userId,
    String tokenId,
    String databaseName,
  ) async {
    try {
      // Construct the URL to query Firestore for the user's document using their userId and databaseName
      final url =
          'https://firestore.googleapis.com/v1/projects/${auth.projectId}/databases/$databaseName/documents/users/$userId';
      // Send an HTTP GET request to Firestore with the necessary authorization token in the header

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Bearer $tokenId', // Authorization header with the Firebase token
        },
      );
      // If the response status is 200 (OK), parse the response body

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        // Extract the language code from the response body
        final languageCode =
            responseBody['fields']['languageCode']['stringValue'];
        return languageCode;
      } else {
        // If the request fails, log the response body and return null
        return null;
      }
    } catch (e) {
      // Log any error that occurs during the HTTP request and return null
      return "Error: $e";
    }
  }
}
