import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:firebase_dart_admin_auth_sdk/src/firebase_app.dart';

// Mock FirebaseStorage class for context
class FirebaseStorage {
  final String projectId;
  final String apiKey;
  final String bucketName;

  // Private constructor
  FirebaseStorage._(this.projectId, this.apiKey, this.bucketName);

  // Method to create and get the FirebaseStorage instance associated with the FirebaseApp
  static FirebaseStorage getStorage({
    required String apiKey,
    required String projectId,
    required String bucketName,
  }) {
    // Ensure that FirebaseApp is initialized
    final firebaseApp = FirebaseApp.instance;

    // Use FirebaseApp's projectId and apiKey
    final projectId = firebaseApp.getAuth().projectId;
    final apiKey = firebaseApp.getAuth().apiKey;
    final bucketName = firebaseApp.getAuth().bucketName;
    // Return a new instance of FirebaseStorage
    return FirebaseStorage._(projectId!, apiKey!, bucketName!);
  }

  // Method to upload a file using HTTP
  Future<void> uploadFile(String path, List<int> fileData) async {
    // Encode the path to handle spaces and special characters
    final encodedPath = Uri.encodeComponent(path);
    final url =
        'https://firebasestorage.googleapis.com/v0/b/$bucketName/o/$encodedPath?uploadType=media';
    final headers = {
      'Authorization':
          'Bearer ${await _getAccessToken()}', // Obtain a valid token
      'Content-Type': 'application/octet-stream',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: fileData,
      );

      if (response.statusCode == 200) {
        print('File uploaded successfully');
      } else {
        print('Failed to upload file: ${response.body}');
        throw Exception('Failed to upload file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading file: $e');
      rethrow;
    }
  }

  // Replace this method with actual access token retrieval logic
  Future<String> _getAccessToken() async {
    // Implement the logic to get an access token (e.g., using Firebase Auth, OAuth2, etc.)
    // This is a placeholder and must be replaced with your token retrieval method.
    return 'your_actual_token_here';
  }
}
