import 'dart:convert';
import 'package:stream_channel/stream_channel.dart';

/// A Socket.IO inspired adapter for DartStream WebSockets.
/// Provides an event-based API.
class DSSocketIoAdapter {
  final StreamChannel<dynamic> channel;
  final Map<String, List<Function(dynamic)>> _eventHandlers = {};

  DSSocketIoAdapter(this.channel) {
    channel.stream.listen((data) {
      _handleIncomingData(data);
    });
  }

  void _handleIncomingData(dynamic data) {
    try {
      final decoded = jsonDecode(data as String);
      if (decoded is Map && decoded.containsKey('event') && decoded.containsKey('data')) {
        final event = decoded['event'] as String;
        final payload = decoded['data'];
        
        if (_eventHandlers.containsKey(event)) {
          for (final handler in _eventHandlers[event]!) {
            handler(payload);
          }
        }
      }
    } catch (e) {
      // Not a JSON or not a Socket.IO format message, ignore or handle differently
    }
  }

  /// Registers a handler for a specific event.
  void on(String event, Function(dynamic) handler) {
    _eventHandlers.putIfAbsent(event, () => []).add(handler);
  }

  /// Emits an event with data to the client.
  void emit(String event, dynamic data) {
    channel.sink.add(jsonEncode({
      'event': event,
      'data': data,
    }));
  }

  /// Closes the connection.
  void disconnect() {
    channel.sink.close();
  }
}
