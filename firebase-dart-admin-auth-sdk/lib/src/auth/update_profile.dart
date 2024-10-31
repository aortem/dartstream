import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user.dart';

class UpdateProfile {
  final FirebaseAuth auth;

  UpdateProfile(this.auth);

  Future<User> updateProfile(
    String displayName,
    String displayImage,
    String? idToken,
  ) async {
    try {
      assert(idToken != null, 'Id token cannot be null');
      final response = await auth.performRequest(
        'update',
        {
          "idToken": idToken,
          "displayName": displayName,
          "photoUrl": displayImage,
          "returnSecureToken": true,
        },
      );
      User user = User.fromJson(response.body);
      auth.updateCurrentUser(user);
      return user;
    } catch (e) {
      print('Update profile failed: $e');
      throw FirebaseAuthException(
        code: 'update-profile',
        message: 'Failed to update user.',
      );
    }
  }
}
