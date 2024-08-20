// import 'package:flutter/material.dart';
// import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
// import 'package:firebase_dart_admin_auth_sdk/src/auth_provider.dart';

// class SignInWithPhoneNumberScreen extends StatefulWidget {
//   const SignInWithPhoneNumberScreen({Key? key}) : super(key: key);

//   @override
//   _SignInWithPhoneNumberScreenState createState() =>
//       _SignInWithPhoneNumberScreenState();
// }

// // class _SignInWithPhoneNumberScreenState
// //     extends State<SignInWithPhoneNumberScreen> {
// //   final FirebaseAuth _auth = FirebaseAuth();
// //   final TextEditingController _phoneNumberController = TextEditingController();
// //   final TextEditingController _smsCodeController = TextEditingController();

// //   String? _verificationId;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Sign In with Phone Number'),
// //       ),
// //       body: Padding(
// //         padding: EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.stretch,
// //           children: [
// //             TextField(
// //               controller: _phoneNumberController,
// //               decoration: InputDecoration(labelText: 'Phone Number'),
// //               keyboardType: TextInputType.phone,
// //             ),
// //             SizedBox(height: 16),
// //             ElevatedButton(
// //               child: Text('Send Verification Code'),
// //               onPressed: _verifyPhoneNumber,
// //             ),
// //             SizedBox(height: 16),
// //             TextField(
// //               controller: _smsCodeController,
// //               decoration: InputDecoration(labelText: 'SMS Code'),
// //               keyboardType: TextInputType.number,
// //             ),
// //             SizedBox(height: 16),
// //             ElevatedButton(
// //               child: Text('Sign In'),
// //               onPressed: _signInWithPhoneNumber,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Future<void> _verifyPhoneNumber() async {
// //     try {
// //       await _auth.verifyPhoneNumber(
// //         phoneNumber: _phoneNumberController.text,
// //         verificationCompleted: (PhoneAuthCredential credential) async {
// //           await _auth.signInWithCredential(credential);
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text('Auto-verified and signed in successfully')),
// //           );
// //         },
// //         verificationFailed: (FirebaseAuthException e) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text('Verification failed: ${e.message}')),
// //           );
// //         },
// //         codeSent: (String verificationId, int? resendToken) {
// //           setState(() {
// //             _verificationId = verificationId;
// //           });
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text('Verification code sent')),
// //           );
// //         },
// //         codeAutoRetrievalTimeout: (String verificationId) {
// //           setState(() {
// //             _verificationId = verificationId;
// //           });
// //         },
// //       );
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error: ${e.toString()}')),
// //       );
// //     }
// //   }

// //   Future<void> _signInWithPhoneNumber() async {
// //     if (_verificationId == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Please verify your phone number first')),
// //       );
// //       return;
// //     }

// //     try {
// //       final credential = PhoneAuthProvider.instance.credential(
// //         verificationId: _verificationId!,
// //         smsCode: _smsCodeController.text,
// //       );
// //       await _auth.signInWithCredential(credential);
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Signed in successfully')),
// //       );
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error: ${e.toString()}')),
// //       );
// //     }
// //   }
// // }
