import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import '../../firebase_dart_admin_auth_sdk.dart';

class PersistenceService {
  final FirebaseAuth auth;

  PersistenceService({required this.auth});

  Future<void> setPersistence(String userId, String tokenId,
      String persistenceType, String databaseName) async {
    try {
      // Construct the Firestore document URL using the databaseName
      final url =
          'https://firestore.googleapis.com/v1/projects/${auth.projectId}/databases/$databaseName/documents/users/$userId';

      final body = jsonEncode({
        "fields": {
          "persistence": {"stringValue": persistenceType}
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
        print('Persistence set to $persistenceType');
      } else {
        print('Failed to set persistence: ${response.body}');
      }
    } catch (e) {
      print('Error setting persistence: $e');
    }
  }
}
