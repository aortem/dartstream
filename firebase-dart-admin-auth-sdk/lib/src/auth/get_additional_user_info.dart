import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user.dart';

class GetAdditionalUserInfo {
  final FirebaseAuth auth;

  GetAdditionalUserInfo({required this.auth});

  Future<User> getAdditionalUserInfo(String? idToken) async {
    try {
      assert(idToken != null, 'Id token cannot be null');
      final response = await auth.performRequest(
        'lookup',
        {
          "idToken": idToken,
        },
      );

      User user = User.fromJson((response.body['users'] as List)[0]);
      auth.updateCurrentUser(user);
      return user;
    } catch (e) {
      print('Get additional user info failed: $e');
      throw FirebaseAuthException(
        code: 'get-additonal-user-info',
        message: 'Failed to get additonal user info',
      );
    }
  }
}
