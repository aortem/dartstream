import 'dart:convert';
import 'package:stream_channel/stream_channel.dart';

/// A Soketi (Pusher) inspired adapter for DartStream WebSockets.
/// Implements basic channel-based communication.
class DSSoketiAdapter {
  final StreamChannel<dynamic> channel;
  final Map<String, List<Function(dynamic)>> _eventHandlers = {};

  DSSoketiAdapter(this.channel) {
    channel.stream.listen((data) {
      _handleIncomingData(data);
    });
    
    // Send connection established event (Pusher style)
    emit('pusher:connection_established', {
      'socket_id': 'ds-${DateTime.now().millisecondsSinceEpoch}',
      'activity_timeout': 120,
    });
  }

  void _handleIncomingData(dynamic data) {
    try {
      final decoded = jsonDecode(data as String);
      final event = decoded['event'] as String?;
      final payload = decoded['data'];
      
      if (event != null && _eventHandlers.containsKey(event)) {
        for (final handler in _eventHandlers[event]!) {
          handler(payload);
        }
      }
    } catch (e) {
      // Handle non-JSON or invalid format
    }
  }

  /// Registers a handler for a specific event.
  void on(String event, Function(dynamic) handler) {
    _eventHandlers.putIfAbsent(event, () => []).add(handler);
  }

  /// Emits an event to the client.
  void emit(String event, dynamic data, {String? channelName}) {
    channel.sink.add(jsonEncode({
      'event': event,
      if (channelName != null) 'channel': channelName,
      'data': data,
    }));
  }
}
