import 'dart:async';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

typedef NextOrObserver<T> = void Function(T?);
typedef ErrorFn = void Function(
    FirebaseAuthException error, StackTrace? stackTrace);
typedef CompleteFn = void Function();
typedef Unsubscribe = void Function();

class OnIdTokenChangedService {
  final FirebaseAuth _auth;
  final StreamController<User?> _controller =
      StreamController<User?>.broadcast();

  OnIdTokenChangedService(this._auth) {
    _auth.idTokenChangedController.stream.listen(
      (User? user) {
        _notifyListeners(user);
      },
      onError: (Object error, StackTrace stackTrace) {
        _notifyError(error, stackTrace);
      },
    );
  }

  Unsubscribe onIdTokenChanged(
    NextOrObserver<User?> nextOrObserver, {
    ErrorFn? error,
    CompleteFn? completed,
  }) {
    final subscription = _controller.stream.listen(
      (User? user) {
        if (nextOrObserver is Function) {
          nextOrObserver(user);
        } else {
          nextOrObserver.call(user);
        }
      },
      onError: (Object e, StackTrace s) {
        if (error != null) {
          if (e is FirebaseAuthException) {
            error(e, s);
          } else {
            error(
                FirebaseAuthException(
                  code: 'unknown',
                  message: e.toString(),
                ),
                s);
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

  void dispose() {
    _controller.close();
  }
}
