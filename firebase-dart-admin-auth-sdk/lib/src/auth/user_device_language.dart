import 'dart:developer';

import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class UseDeviceLanguageService {
  final FirebaseAuth auth;

  UseDeviceLanguageService({required this.auth});

  Future<String?> useDeviceLanguage(String userId, String languageCode) async {
    try {
      final url = 'lookup';
      final body = {
        'idToken': userId,
      };

      final response = await auth.performRequest(url, body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = response.body;

        final List users = responseBody['users'] ?? [];

        if (users.isNotEmpty) {
          final String? languageCode = users[0]['languageCode'];
          log("No devise Language is set");
          return languageCode;
        } else {
          print('User not found.');
          return null;
        }
      } else {
        print('update : ${response.body}');
      }
    } catch (e) {
      print('Use device language failed: $e');
      throw FirebaseAuthException(
        code: 'use-device-language-error',
        message: 'Failed to set device language.',
      );
    }
  }
}
