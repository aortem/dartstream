import 'dart:async';
import 'package:firebase_dart_admin_auth_sdk/src/user.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';

class AuthStateChangedService {
  final FirebaseAuth _auth;
  final StreamController<User?> _controller =
      StreamController<User?>.broadcast();

  AuthStateChangedService({required FirebaseAuth auth}) : _auth = auth {
    // Listen to the auth instance for auth state changes
    _auth.authStateChangedController.stream.listen((user) {
      _controller.add(user);
    });
  }

  Stream<User?> onAuthStateChanged() {
    return _controller.stream;
  }

  void dispose() {
    _controller.close();
  }
}
