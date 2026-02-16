// ds_event_listeners.dart

/// Interface for listening to events in the Dartstream framework.
abstract class DartstreamEventListener {
  /// Called when an event occurs.
  void onEvent(String eventName, Map<String, dynamic> eventData);
}

/// Manages event registration and dispatching for Dartstream.
class DartstreamEventDispatcher {
  // Holds a list of registered event listeners.
  final List<DartstreamEventListener> _listeners = [];

  /// Registers an event listener.
  void registerListener(DartstreamEventListener listener) {
    _listeners.add(listener);
  }

  /// Dispatches an event to all registered listeners.
  void dispatchEvent(String eventName, Map<String, dynamic> eventData) {
    for (var listener in _listeners) {
      listener.onEvent(eventName, eventData);
    }
  }

  /// Removes a listener when it no longer needs to listen for events.
  void removeListener(DartstreamEventListener listener) {
    _listeners.remove(listener);
  }
}

/// Standard events used within Dartstream for consistency across extensions.
class DartstreamEvents {
  static const String extensionInitialized = 'extension_initialized';
  static const String extensionDisposed = 'extension_disposed';
  static const String dataUpdated = 'data_updated';
  static const String userLoggedIn = 'user_logged_in';
  // Add other standard events as needed.
}

/// Example listener that logs events for demonstration purposes.
class LoggingEventListener implements DartstreamEventListener {
  @override
  void onEvent(String eventName, Map<String, dynamic> eventData) {
    print('Event: $eventName, Data: $eventData');
  }
}
