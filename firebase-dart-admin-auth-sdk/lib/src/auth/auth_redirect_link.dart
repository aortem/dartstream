
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class SignInWithRedirectService {
  final FirebaseAuth auth;

  SignInWithRedirectService({required this.auth});

  Future<UserCredential> signInWithRedirect(String providerId) async {
    try {
      final url = 'v1/accounts:signInWithRedirect';
      final body = {
        'providerId': providerId,
      };
      
   final response=   await auth.performRequest(url, body);

       final userCredential = UserCredential.fromJson(response);
    auth.updateCurrentUser(userCredential.user);
    return userCredential;
    } catch (e) {
      print('Sign-in with redirect failed: $e');
      throw FirebaseAuthException(
        code: 'sign-in-redirect-error',
        message: 'Failed to sign in with redirect.',
      );
    }
  }
}
