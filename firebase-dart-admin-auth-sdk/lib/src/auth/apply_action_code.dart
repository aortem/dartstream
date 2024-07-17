import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';

class ApplyActionCode {
  final FirebaseAuth auth;

  ApplyActionCode(this.auth);

  Future<UserCredential> applyActionCode(String actionCode) async {
    final response = await auth.performRequest(
      'update',
      {
        'oobCode': actionCode,
      },
    );

    final userCredential = UserCredential.fromJson(response);
    auth.updateCurrentUser(userCredential.user);
    return userCredential;
  }
}
