import 'dart:async';
import 'dart:developer';
import 'dart:convert';
import 'dart:html';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import '../../firebase_dart_admin_auth_sdk.dart';

class FirebasePhoneNumberLink {
  final FirebaseAuth auth;

  FirebasePhoneNumberLink({required this.auth});

  Future<void> sendVerificationCode(String phoneNumber) async {
    final reCaptchaVerifier = DivElement()..id = 'recaptcha-container';
    document.body!.append(reCaptchaVerifier);

    // Step 2: Wait for the user to complete the reCAPTCHA
    // This is done automatically by Firebase in the web environment
    final reCaptchaResponse = await _executeRecaptcha('your-site-key');

    // Step 3: Send the verification code to the phone number
    final sessionInfo = await sendPhoneVerificationCode(
        phoneNumber, reCaptchaResponse!, auth.apiKey!);

    if (sessionInfo != null) {
      // Simulate user input for the verification code
      final verificationCode = await _getVerificationCodeFromUser();

      // Step 4: Verify the phone number with the received verification code
      final idToken =
          await verifyPhoneNumber(sessionInfo, verificationCode, auth.apiKey!);

      if (idToken != null) {
        // Step 5: Link the phone number with the Firebase user account
        await linkPhoneNumberToAccount(
            idToken, phoneNumber, sessionInfo, verificationCode, auth.apiKey!);
      }
    }

    //
    // Future<void> firebasePhoneAuthWithReCaptcha(String phoneNumber) async {
    //   // Step 1: Render reCAPTCHA widget in the web app
    //
    // }

//     try {
//       final url = 'sendVerificationCode';
//       final body = {
//        'phoneNumber': phoneNumber,
//       'returnSecureToken': true,
//       };
//
//          final response = await auth.performRequest(url, body);
// log("response$response");
//
//
//     } catch (e) {
//       print('Verify code failed: $e');
//       throw FirebaseAuthException(
//         code: 'verify-code-error',
//         message: 'Failed to verify phone number code.',
//       );
//     }
  }

  Future<String?> _executeRecaptcha(String siteKey) async {
    final completer = Completer<String>();

    // Wait until the reCAPTCHA script is fully loaded
    final script = ScriptElement()
      ..src = 'https://www.google.com/recaptcha/api.js?render=explicit'
      ..async = true
      ..onLoad.listen((_) {
        // Execute the reCAPTCHA when the script is loaded
        _renderRecaptcha(siteKey, completer);
      });

    document.body!.append(script);

    return completer.future;
  }

  void _renderRecaptcha(String siteKey, Completer<String> completer) {
    final script = ScriptElement();
    script.text = '''
    grecaptcha.ready(function() {
      grecaptcha.execute('$siteKey', {action: 'submit'}).then(function(token) {
        window.postMessage({'recaptchaToken': token}, '*');
      });
    });
  ''';
    document.body!.append(script);

    // Listen for the reCAPTCHA response
    window.onMessage.listen((event) {
      if (event.data != null && event.data['recaptchaToken'] != null) {
        completer.complete(event.data['recaptchaToken']);
      }
    });
  }

  Future<String> _getVerificationCodeFromUser() async {
    // Simulate getting the verification code from the user
    // In a real application, you would use a form field to capture this input
    return Future.value('123456');
  }

  Future<String?> sendPhoneVerificationCode(
      String phoneNumber, String reCaptchaToken, String apiKey) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:sendVerificationCode?key=$apiKey');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'phoneNumber': phoneNumber,
        'recaptchaToken': reCaptchaToken,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['sessionInfo'];
    } else {
      print('Failed to send verification code: ${response.body}');
      return null;
    }
  }

  Future<String?> verifyPhoneNumber(
      String sessionInfo, String verificationCode, String apiKey) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPhoneNumber?key=$apiKey');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'sessionInfo': sessionInfo,
        'code': verificationCode,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['idToken'];
    } else {
      print('Failed to verify phone number: ${response.body}');
      return null;
    }
  }

  Future<void> linkPhoneNumberToAccount(String idToken, String phoneNumber,
      String sessionInfo, String verificationCode, String apiKey) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:update?key=$apiKey');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'idToken': idToken,
        'phoneNumber': phoneNumber,
        'sessionInfo': sessionInfo,
        'code': verificationCode,
        'returnSecureToken': true,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newIdToken = data['idToken'];
      print('Phone number linked successfully. New ID Token: $newIdToken');
    } else {
      print('Failed to link phone number: ${response.body}');
    }
  }

  Future<void> verifyCodeAndLinkPhoneNumber(String verificationId,
      String verificationCode, String phoneNumber) async {
    final url = 'signInWithPhoneNumber';
    final body = {
      'verificationId': verificationId,
      'code': verificationCode,
    };

    final response = await auth.performRequest(url, body);
    log("reaponae is $response");

    final idToken = response.body['idToken'];

    // Optionally, link the phone number with the current user if needed
    await linkPhoneNumber(idToken, phoneNumber);
  }

  Future<void> linkPhoneNumber(String idToken, String phoneNumber) async {
    try {
      final url = 'update';
      final body = {
        'idToken': idToken,
        'phoneNumber': phoneNumber,
        'returnSecureToken': true,
      };
      await auth.performRequest(url, body);

      print('Phone number linked successfully');
    } catch (e) {
      print('Verify password reset code failed: $e');
      throw FirebaseAuthException(
        code: 'verify-password-reset-code-error',
        message: 'Failed to verify password reset code.',
      );
    }
  }
}
