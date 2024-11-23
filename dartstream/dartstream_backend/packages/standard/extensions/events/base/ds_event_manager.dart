class EventManager {
  final Map<String, List<void Function(dynamic)>> _listeners = {};

  void subscribe(String event, void Function(dynamic) callback) {
    _listeners.putIfAbsent(event, () => []).add(callback);
  }

  void publish(String event, dynamic data) {
    if (_listeners.containsKey(event)) {
      for (var listener in _listeners[event]!) {
        listener(data);
      }
    } else {
      print('No subscribers for event: $event');
    }
  }
}
