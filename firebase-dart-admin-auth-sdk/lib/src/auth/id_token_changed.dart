import 'dart:async';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

///next or
typedef NextOrObserver<T> = void Function(T?);

///error
typedef ErrorFn =
    void Function(FirebaseAuthException error, StackTrace? stackTrace);

///complete
typedef CompleteFn = void Function();

///unsubscribe
typedef Unsubscribe = void Function();

///on id token
class OnIdTokenChangedService {
  final FirebaseAuth _auth;
  final StreamController<User?> _controller =
      StreamController<User?>.broadcast();

  ///on id token
  OnIdTokenChangedService(this._auth) {
    // Listen to the simplified stream from FirebaseAuth
    _auth.onIdTokenChanged().listen(
      (User? user) {
        _notifyListeners(user);
      },
      onError: (Object error, StackTrace stackTrace) {
        _notifyError(error, stackTrace);
      },
    );
  }

  ///on id token
  Unsubscribe onIdTokenChanged(
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
          if (e is FirebaseAuthException) {
            error(e, s);
          } else {
            error(
              FirebaseAuthException(code: 'unknown', message: e.toString()),
              s,
            );
          }
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

  void _notifyError(Object error, StackTrace stackTrace) {
    _controller.addError(error, stackTrace);
  }

  ///dispose
  void dispose() {
    _controller.close();
  }
}
