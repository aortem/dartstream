import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user.dart';

class UnlinkProvider {
  final FirebaseAuth auth;

  UnlinkProvider({required this.auth});

  Future<User> unlinkProvider(String? idToken, String providerId) async {
    try {
      assert(idToken != null, 'Id token cannot be null');
      assert(providerId.isNotEmpty, 'ProvideId cannot be an empty string');
      assert(auth.currentUser != null, 'User not signed in');
      final response = await auth.performRequest(
        'update',
        {
          "idToken": idToken,
          "deleteProvider": [providerId]
        },
      );
      User user = User.fromJson(response);
      auth.updateCurrentUser(user);
      return user;
    } catch (e) {
      print('Unlink provider action failed: $e');
      throw FirebaseAuthException(
        code: 'unlink-provider',
        message: 'Failed to unlink provider',
      );
    }
  }
}
