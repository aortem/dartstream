import 'dart:async';
import 'package:ds_shelf/ds_shelf.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Callback for when a new WebSocket connection is established.
typedef OnConnectionCallback = void Function(WebSocketChannel channel, String? protocol);

/// Core handler for WebSocket connections in DartStream.
class DSWebSocketHandler {
  final Set<WebSocketChannel> _activeChannels = {};
  final OnConnectionCallback? onConnection;

  DSWebSocketHandler({this.onConnection});

  /// The shelf handler that upgrades connections to WebSockets.
  Handler get handler {
    return webSocketHandler((WebSocketChannel channel, String? protocol) {
      _activeChannels.add(channel);
      
      if (onConnection != null) {
        onConnection!(channel, protocol);
      }

      // Use channel.sink.done to clean up active channels when the connection closes.
      // This avoids listening to the single-subscription stream, allowing adapters
      // or callbacks to subscribe to the stream themselves.
      channel.sink.done.then((_) {
        _activeChannels.remove(channel);
      }).catchError((error) {
        print('WebSocket Error: $error');
        _activeChannels.remove(channel);
      });
    });
  }

  /// Broadcasts a message to all active WebSocket connections.
  void broadcast(dynamic message, {WebSocketChannel? exclude}) {
    for (final channel in _activeChannels) {
      if (channel != exclude) {
        channel.sink.add(message);
      }
    }
  }

  /// Returns the number of active connections.
  int get connectionCount => _activeChannels.length;

  /// Closes all active connections.
  Future<void> closeAll() async {
    final futures = _activeChannels.map((c) => c.sink.close()).toList();
    await Future.wait(futures);
    _activeChannels.clear();
  }
}
