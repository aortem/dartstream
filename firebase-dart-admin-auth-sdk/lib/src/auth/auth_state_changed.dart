import 'dart:async';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class AuthStateChangedService {
  final FirebaseAuth auth;

  AuthStateChangedService({required this.auth});

  Stream<User?> onAuthStateChanged() {
    return auth.authStateChangedController.stream;
  }

  void simulateAuthStateChange(User? user) {
    auth.authStateChangedController.add(user);
  }
}
