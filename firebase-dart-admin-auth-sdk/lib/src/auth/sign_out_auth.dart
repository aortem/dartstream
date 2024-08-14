import '../../firebase_dart_admin_auth_sdk.dart';

class FirebaseSignOUt {
  Future<void> signOut() async {

    FirebaseApp.instance.setCurrentUser(null);
  }
}
