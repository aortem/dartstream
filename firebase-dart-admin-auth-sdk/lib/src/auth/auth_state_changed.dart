import 'dart:async';
import 'package:firebase_dart_admin_auth_sdk/src/user.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';

/// Service to monitor and manage Firebase authentication state changes.
///
/// This service listens to the Firebase authentication state and
/// provides a stream of `User` objects, which represent the currently
/// authenticated user or `null` if no user is signed in.
class AuthStateChangedService {
  /// The [FirebaseAuth] instance used to listen for authentication state changes.
  final FirebaseAuth _auth;

  /// A [StreamController] to broadcast authentication state changes.
  final StreamController<User?> _controller =
      StreamController<User?>.broadcast();

  /// Constructs an instance of [AuthStateChangedService].
  ///
  /// Parameters:
  /// - [auth]: The [FirebaseAuth] instance that triggers the auth state events.
  ///
  /// The constructor sets up a listener on the provided [_auth] instance, which
  /// broadcasts any user state changes to listeners of [_controller].
  AuthStateChangedService({required FirebaseAuth auth}) : _auth = auth {
    // Listen to the auth instance for auth state changes
    _auth.authStateChangedController.stream.listen((user) {
      _controller.add(user);
    });
  }

  /// Provides a stream that emits the current user on authentication state changes.
  ///
  /// Returns a [Stream] that emits the current `User` when the authentication
  /// state changes, or `null` if there is no authenticated user.
  Stream<User?> onAuthStateChanged() {
    return _controller.stream;
  }

  /// Disposes the [AuthStateChangedService] by closing the stream controller.
  ///
  /// This should be called when the service is no longer needed to prevent
  /// memory leaks.
  void dispose() {
    _controller.close();
  }
}
