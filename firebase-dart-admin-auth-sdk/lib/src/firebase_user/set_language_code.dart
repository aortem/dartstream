import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import '../../firebase_dart_admin_auth_sdk.dart';

class LanguageService {
  final FirebaseAuth auth;

  LanguageService({required this.auth});

  // Simulated function to "set" the language code
  Future<void> setLanguagePreference(
      String userId, String tokenId, String languageCode) async {
    try {
      // This example assumes you're storing the language code in a Firestore document.
      final url =
          'https://firestore.googleapis.com/v1/projects/${auth.projectId}/databases/(default)/documents/users/$userId';

      final body = jsonEncode({
        "fields": {
          "languageCode": {"stringValue": languageCode}
        }
      });

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenId',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print('Language preference set successfully.');
      } else {
        print('Failed to set language preference: ${response.body}');
      }
    } catch (e) {
      print('Error setting language preference: $e');
    }
  }

  // Function to retrieve the language preference
}
