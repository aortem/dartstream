import 'package:aortem_firebase_dart_sdk/auth.dart';
import 'package:aortem_firebase_dart_sdk/implementation/pure_dart.dart';
import 'package:aortem_firebase_dart_sdk/src/core.dart';

Future<Map<String, dynamic>> webGetAuthResult() async {
  throw UnimplementedError();
}

void webLaunchUrl(Uri uri, {bool popup = false}) {
  throw UnimplementedError();
}

class DefaultAuthHandler implements AuthHandler {
  const DefaultAuthHandler();

  @override
  Future<AuthCredential?> getSignInResult(FirebaseApp app) async {
    return null;
  }

  @override
  Future<bool> signIn(FirebaseApp app, AuthProvider provider,
      {bool isPopup = false}) async {
    return false;
  }

  @override
  Future<void> signOut(FirebaseApp app, User user) async {}
}
