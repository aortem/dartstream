import 'dart:convert';
import 'package:http/http.dart' as http;
import '../exceptions.dart';

class RecaptchaConfigService {
  final dynamic auth;

  RecaptchaConfigService({required this.auth});

  Future<void> initializeRecaptchaConfig() async {
    try {
      final url = Uri.https(
        'identitytoolkit.googleapis.com',
        '/v1/recaptchaConfig',
        {'key': auth.apiKey},
      );

      final response = await http.post(url);

      if (response.statusCode != 200) {
        final error = json.decode(response.body)['error'];
        throw FirebaseAuthException(
          code: error['message'],
          message: error['message'],
        );
      }

      // Process the reCAPTCHA config response if needed
      final data = json.decode(response.body);
      // TODO: Store or use the reCAPTCHA config as needed
      print('reCAPTCHA config initialized: $data');
    } catch (e) {
      throw FirebaseAuthException(
        code: 'recaptcha-config-error',
        message: 'Failed to initialize reCAPTCHA config: ${e.toString()}',
      );
    }
  }
}