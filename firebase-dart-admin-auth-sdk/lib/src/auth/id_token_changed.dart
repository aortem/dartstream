import 'dart:async';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class IdTokenChangedService {
  final FirebaseAuth auth;

  IdTokenChangedService({required this.auth});

  Stream<User?> onIdTokenChanged() {
    return auth.idTokenChangedController.stream;
  }

  void simulateIdTokenChange(User? user) {
    auth.idTokenChangedController.add(user);
  }
}
