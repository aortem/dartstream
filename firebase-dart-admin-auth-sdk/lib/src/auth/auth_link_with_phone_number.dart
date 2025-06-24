import 'dart:async';
import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import '../../firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';

/// A class to handle phone number linking and verification using Firebase Authentication.
class FirebasePhoneNumberLink {
  /// The FirebaseAuth instance used for interacting with Firebase Authentication.

  final FirebaseAuth auth;

  /// Constructor that initializes the `FirebasePhoneNumberLink` with the provided [auth] instance.
  FirebasePhoneNumberLink(this.auth);

  /// Sends a phone number verification code to the given [phoneNumber].
  ///
  /// This method makes a request to Firebase's Identity Toolkit API to send a verification code
  /// to the provided phone number. The reCAPTCHA token must be generated and provided to verify
  /// that the request is legitimate. The [phoneNumber] is the phone number to which the code will
  /// be sent.
  ///
  /// Throws an error if the request fails or the verification code cannot be sent.
  Future<void> sendVerificationCode(String phoneNumber) async {
    String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:sendVerificationCode';
    if (auth.apiKey != 'your_api_key') {
      url = '$url?key=${auth.apiKey}';
    }
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        if (auth.accessToken != null)
          'Authorization': 'Bearer ${auth.accessToken}',
      },
      body: json.encode({
        'phoneNumber': phoneNumber,
        'recaptchaToken':
            '[RECAPTCHA_TOKEN]', // You need to handle reCAPTCHA verification
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Verification code sent. Session Info: ${data['sessionInfo']}');
      // Store the sessionInfo for later use in the linking process
    } else {
      print('Failed to send verification code: ${response.body}');
    }
  }

  /// Links a phone number to an existing user account using the provided [idToken],
  /// [phoneNumber], and [verificationCode].
  ///
  /// This method sends a request to Firebase's Identity Toolkit API to link a phone number
  /// to an account identified by the [idToken]. It requires the phone number and a valid
  /// verification code, which is usually received via SMS after the user initiates phone number
  /// verification. The [returnSecureToken] flag is set to true to ensure that a new secure token
  /// is returned with the update.
  ///
  /// [idToken] is the user's Firebase authentication ID token.
  /// [phoneNumber] is the phone number to be linked.
  /// [verificationCode] is the SMS code that was sent to the user's phone.
  Future<void> linkPhoneNumber(
    String idToken,
    String phoneNumber,
    String verificationCode,
  ) async {
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

    // Add other methods here as necessary for further functionality
  }
}
