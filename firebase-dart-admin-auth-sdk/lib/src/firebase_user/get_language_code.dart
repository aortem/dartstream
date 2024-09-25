import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import '../../firebase_dart_admin_auth_sdk.dart';

class LanguagGetService {
  final FirebaseAuth auth;

  LanguagGetService({required this.auth});

  Future<String?> getLanguagePreference(
      String userId, String tokenId, String databaseName) async {
    try {
      // Use the databaseName variable in the URL
      final url =
          'https://firestore.googleapis.com/v1/projects/${auth.projectId}/databases/$databaseName/documents/users/$userId';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $tokenId',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final languageCode =
            responseBody['fields']['languageCode']['stringValue'];
        print('Retrieved language preference: $languageCode');
        return languageCode;
      } else {
        print('Failed to retrieve language preference: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error retrieving language preference: $e');
      return null;
    }
  }
}
