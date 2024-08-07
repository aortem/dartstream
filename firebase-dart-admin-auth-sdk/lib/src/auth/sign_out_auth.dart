import '../../firebase_dart_admin_auth_sdk.dart';

class FirebaseSignOUt {
  Future<void> signOut() async {
    await FirebaseApp.instance.getAuth().signOut();
    FirebaseApp.instance.setCurrentUser(null);
  }
}
