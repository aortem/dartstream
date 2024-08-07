import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';

abstract class AuthBase {
  final FirebaseAuth auth;

  AuthBase(this.auth);

  Future<Map<String, dynamic>> performRequest(
      String endpoint, Map<String, dynamic> body) {
    return auth.performRequest(endpoint, body);
  }
}
