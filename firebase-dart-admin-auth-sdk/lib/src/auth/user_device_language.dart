import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class UseDeviceLanguageService {
  final FirebaseAuth auth;

  UseDeviceLanguageService({required this.auth});

  Future<void> useDeviceLanguage(String userId, String languageCode) async {
    try {
      final url = 'update';
      final body = {
        'idToken': userId,
        'languageCode': languageCode,
      };

      await auth.performRequest(url, body);
    } catch (e) {
      print('Use device language failed: $e');
      throw FirebaseAuthException(
        code: 'use-device-language-error',
        message: 'Failed to set device language.',
      );
    }
  }
}
