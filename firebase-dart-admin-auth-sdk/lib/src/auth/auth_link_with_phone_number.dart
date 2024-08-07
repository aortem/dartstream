

import 'dart:developer';

import '../../firebase_dart_admin_auth_sdk.dart';

class FirebasePhoneNumberLink{
final FirebaseAuth auth;

  FirebasePhoneNumberLink({required this.auth});

  Future<void> sendVerificationCode(String phoneNumber) async {



    try {
      final url = 'sendVerificationCode';
      final body = {
       'phoneNumber': phoneNumber,
      'returnSecureToken': true,
      };

         final response = await auth.performRequest(url, body);


       
    } catch (e) {
      print('Verify code failed: $e');
      throw FirebaseAuthException(
        code: 'verify-code-error',
        message: 'Failed to verify phone number code.',
      );
    }








  
}


Future<void> verifyCodeAndLinkPhoneNumber(String verificationId, String verificationCode,String phoneNumber) async {
  final url =
    'signInWithPhoneNumber';
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