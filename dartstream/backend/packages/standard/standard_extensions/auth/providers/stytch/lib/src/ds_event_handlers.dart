enum DSAuthEventType { signedIn, signedOut, error }

class DSAuthEvent {
  final DSAuthEventType type;
  final String? message;

  DSAuthEvent(this.type, {this.message});
}

class DSStytchEventHandler {
  final void Function(DSAuthEvent event) onEvent;

  DSStytchEventHandler({required this.onEvent});
}
