import '../firebase_auth.dart';

abstract class AuthBase {
  final FirebaseAuth auth;

  AuthBase(this.auth);

  Future<Map<String, dynamic>> performRequest(
      String endpoint, Map<String, dynamic> body) {
    return auth.performRequest(endpoint, body);
  }
}
