import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

/// Handles Firebase Authentication events and maps them to DartStream events
class DSFirebaseEventHandler {
  final void Function(DSAuthEvent) onEvent;

  DSFirebaseEventHandler({required this.onEvent});

  void initialize(FirebaseAuth auth) {
    // Listen to auth state changes
    auth.authStateChangedController.stream.listen(_handleAuthStateChange);

    // Listen to token changes
    auth.idTokenChangedController.stream.listen(_handleTokenChange);
  }

  void _handleAuthStateChange(User? user) {
    if (user != null) {
      final isNewUser = user.metadata?.creationTime != null &&
          user.metadata.creationTime == user.metadata.lastSignInTime;

      onEvent(DSAuthEvent(
        type: DSAuthEventType.signedIn,
        data: {
          'userId': user.uid,
          'email': user.email,
          'isNewUser':
              isNewUser, // Set to false or use logic based on availability
        },
      ));
    } else {
      onEvent(DSAuthEvent(
        type: DSAuthEventType.signedOut,
        data: {},
      ));
    }
  }

  void _handleTokenChange(User? user) {
    if (user != null) {
      user.getIdToken().then((token) {
        onEvent(DSAuthEvent(
          type: DSAuthEventType.tokenRefreshed,
          data: {
            'userId': user.uid,
            'token': token,
          },
        ));
      });
    }
  }
}

extension on User {
  get metadata => null;
}

/// Represents a DartStream authentication event
class DSAuthEvent {
  final DSAuthEventType type;
  final Map<String, dynamic> data;

  DSAuthEvent({required this.type, required this.data});
}

/// Types of authentication events in DartStream
enum DSAuthEventType {
  signedIn,
  signedOut,
  tokenRefreshed,
  userUpdated,
  error,
}
