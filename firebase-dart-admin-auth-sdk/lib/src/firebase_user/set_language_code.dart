import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import '../../firebase_dart_admin_auth_sdk.dart';

class LanguageService {
  final FirebaseAuth auth;

  LanguageService({
    required this.auth,
  });

  Future<void> setLanguagePreference(String userId, String tokenId,
      String languageCode, String databaseName) async {
    try {
      // Use the databaseName variable in the URL
      final url =
          'https://firestore.googleapis.com/v1/projects/${auth.projectId}/databases/$databaseName/documents/users/$userId';

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

  getLanguagePreference(String s) {}
}
