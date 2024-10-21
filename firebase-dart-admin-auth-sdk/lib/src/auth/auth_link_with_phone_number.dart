import 'dart:async';

import 'dart:convert';
// import 'dart:html';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import '../../firebase_dart_admin_auth_sdk.dart';

import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';

class FirebasePhoneNumberLink {
  final FirebaseAuth auth;
  FirebasePhoneNumberLink(this.auth);

  Future<void> sendVerificationCode(String phoneNumber) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:sendVerificationCode?key=${auth.apiKey}';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'phoneNumber': phoneNumber,
        'recaptchaToken':
            '[RECAPTCHA_TOKEN]', // You need to handle reCAPTCHA verification
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Verification code sent. Session Info: ${data['sessionInfo']}');
      // Store the sessionInfo for later use
    } else {
      print('Failed to send verification code: ${response.body}');
    }
  }

  // Stub implementation or methods that throw an error when called
  Future<void> linkPhoneNumber(
      String idToken, String phoneNumber, String verificationCode) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:update?key=${auth.apiKey}';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'idToken': idToken,
        'phoneNumber': phoneNumber,
        'verificationCode': verificationCode,
        'returnSecureToken': true,
      }),
    );

    if (response.statusCode == 200) {
      print('Phone number linked successfully');
    } else {
      print('Failed to link phone number: ${response.body}');
    }

    // Add other methods here as necessary
  }
}
