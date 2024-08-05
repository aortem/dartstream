import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk/src/http_response.dart';

class FirebaseParseUrlLink {
  final FirebaseAuth auth;

  FirebaseParseUrlLink({required this.auth});

  Future<HttpResponse> parseActionCodeURL(String oobCode) async {
    try {
      final url = 'parseCode';
      final body = {
        'oobCode': oobCode,
      };

      final response = await auth.performRequest(url, body);

      return response; // Assuming the response is a map containing the parsed action code URL details
    } catch (e) {
      print('Parse action code URL failed: $e');
      throw FirebaseAuthException(
        code: 'parse-action-code-url-error',
        message: 'Failed to parse action code URL.',
      );
    }
  }
}
