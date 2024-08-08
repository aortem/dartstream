import 'dart:convert';
import '../exceptions.dart';

class InitializeRecaptchaConfigService {
  final dynamic auth;

  InitializeRecaptchaConfigService({required this.auth});

  Future<void> initializeRecaptchaConfig() async {
    try {
      final url = Uri.https(
        'identitytoolkit.googleapis.com',
        '/v1/recaptchaConfig',
        {'key': auth.apiKey},
      );

      final response = await auth.httpClient.post(
        url,
        body: json.encode({
          'clientType': 'CLIENT_TYPE_WEB', // Adjust if needed for mobile
        }),
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body)['error'];
        throw FirebaseAuthException(
          code: error['message'],
          message: error['message'],
        );
      }

      final data = json.decode(response.body);

      // Store the reCAPTCHA configuration in the auth instance
      auth.recaptchaConfig = data;

      print('reCAPTCHA configuration loaded successfully');
    } catch (e) {
      throw FirebaseAuthException(
        code: 'recaptcha-config-error',
        message: 'Failed to initialize reCAPTCHA config: ${e.toString()}',
      );
    }
  }
}
