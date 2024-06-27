import '../firebase_auth.dart';
import '../user_credential.dart';

abstract class AuthBase {
  final FirebaseAuth _auth;

  AuthBase(this._auth);

  Future<Map<String, dynamic>> _performRequest(
      String endpoint, Map<String, dynamic> body) {
    return _auth._performRequest(endpoint, body);
  }
}
