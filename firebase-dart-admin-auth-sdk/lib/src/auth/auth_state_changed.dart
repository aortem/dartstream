import 'dart:async';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

///next or
typedef NextOrObserver<T> = void Function(T?);

///Error fn
typedef ErrorFn = void Function(Object error, StackTrace? stackTrace);

///complete
typedef CompleteFn = void Function();

///unsubscribe
typedef Unsubscribe = void Function();

/// Service to monitor and manage Firebase authentication state changes.
///
/// This service listens to the Firebase authentication state and
/// provides a stream of `User` objects, which represent the currently
/// authenticated user or `null` if no user is signed in.
class OnAuthStateChangedService {
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
  OnAuthStateChangedService(this._auth) {
    // Listen to the simplified stream from FirebaseAuth
    _auth.onAuthStateChanged().listen(
      (User? user) {
        _notifyListeners(user);
      },
      onError: (Object error, StackTrace stackTrace) {
        _notifyError(error, stackTrace);
      },
    );
  }

  ///onAuthstateChange
  Unsubscribe onAuthStateChanged(
    NextOrObserver<User?> nextOrObserver, {
    ErrorFn? error,
    CompleteFn? completed,
  }) {
    final subscription = _controller.stream.listen(
      (User? user) {
        nextOrObserver(user);
      },
      onError: (Object e, StackTrace s) {
        if (error != null) {
          error(e, s);
        }
      },
      onDone: completed,
    );

    return () {
      subscription.cancel();
    };
  }

  void _notifyListeners(User? user) {
    _controller.add(user);
  }

  /// Provides a stream that emits the current user on authentication state changes.
  ///
  /// Returns a [Stream] that emits the current `User` when the authentication
  /// state changes, or `null` if there is no authenticated user.
  void _notifyError(Object error, StackTrace stackTrace) {
    _controller.addError(error, stackTrace);
  }

  /// Disposes the [AuthStateChangedService] by closing the stream controller.
  ///
  /// This should be called when the service is no longer needed to prevent
  /// memory leaks.
  void dispose() {
    _controller.close();
  }
}
