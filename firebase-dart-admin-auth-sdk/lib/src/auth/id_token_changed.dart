import 'dart:async';
import 'package:firebase_dart_admin_auth_sdk/src/user.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';

class IdTokenChangedService {
  final FirebaseAuth _auth;
  final StreamController<User?> _controller =
      StreamController<User?>.broadcast();

  IdTokenChangedService({required FirebaseAuth auth}) : _auth = auth {
    // Listen to the auth instance for ID token changes
    _auth.idTokenChangedController.stream.listen((user) {
      _controller.add(user);
    });
  }

  Stream<User?> onIdTokenChanged() {
    return _controller.stream;
  }

  void dispose() {
    _controller.close();
  }
}
