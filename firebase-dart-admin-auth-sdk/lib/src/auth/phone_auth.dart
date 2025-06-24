import 'dart:async';
import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

///phone auth class
class PhoneAuth {
  final FirebaseAuth _auth;
  final http.Client _httpClient;

  ///phone auth
  PhoneAuth(this._auth) : _httpClient = http.Client();

  /// sign in with phone
  Future<ConfirmationResult> signInWithPhoneNumber(
    String phoneNumber,
    ApplicationVerifier appVerifier,
  ) async {
    try {
      final verificationId = await _sendVerificationCode(
        phoneNumber,
        appVerifier,
      );
      return ConfirmationResult(
        verificationId: verificationId,
        confirm: (String smsCode) => _confirmCode(verificationId, smsCode),
      );
    } catch (e) {
      throw _handleSignInError(e);
    }
  }

  Future<String> _sendVerificationCode(
    String phoneNumber,
    ApplicationVerifier appVerifier,
  ) async {
    final url = Uri.https(
      'identitytoolkit.googleapis.com',
      '/v1/accounts:sendVerificationCode',
      {if (_auth.apiKey != 'your_api_key') 'key': _auth.apiKey},
    );

    final response = await _httpClient.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (_auth.accessToken != null)
          'Authorization': 'Bearer ${_auth.accessToken}',
      },
      body: json.encode({
        'phoneNumber': phoneNumber,
        'recaptchaToken': await appVerifier.verify(),
      }),
    );

    if (response.statusCode != 200) {
      throw FirebaseAuthException(
        code: 'send-verification-code-failed',
        message: 'Failed to send verification code',
      );
    }

    final responseData = json.decode(response.body);
    return responseData['sessionInfo'];
  }

  Future<UserCredential> _confirmCode(
    String verificationId,
    String smsCode,
  ) async {
    final url = Uri.https(
      'identitytoolkit.googleapis.com',
      '/v1/accounts:signInWithPhoneNumber',
      {if (_auth.apiKey != 'your_api_key') 'key': _auth.apiKey},
    );

    final response = await _httpClient.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (_auth.accessToken != null)
          'Authorization': 'Bearer ${_auth.accessToken}',
      },
      body: json.encode({'sessionInfo': verificationId, 'code': smsCode}),
    );

    if (response.statusCode != 200) {
      throw FirebaseAuthException(
        code: 'invalid-verification-code',
        message:
            'The SMS verification code used to create the phone auth credential is invalid',
      );
    }

    final responseData = json.decode(response.body);
    final user = User.fromJson(responseData);
    return UserCredential(user: user, additionalUserInfo: null);
  }

  FirebaseAuthException _handleSignInError(dynamic error) {
    if (error is FirebaseAuthException) {
      return error;
    }
    return FirebaseAuthException(
      code: 'phone-auth-error',
      message:
          'An error occurred during phone authentication: ${error.toString()}',
    );
  }
}
