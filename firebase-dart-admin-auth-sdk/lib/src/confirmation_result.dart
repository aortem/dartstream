import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class ConfirmationResult {
  final String verificationId;
  final Future<UserCredential> Function(String) confirm;

  ConfirmationResult({required this.verificationId, required this.confirm});
}
