import 'dart:async';

import 'package:ds_websocket_base/ds_websocket_base_export.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

/// Socket.IO WebSocket provider for DartStream.
class DSSocketIoWebSocketProvider implements DSWebSocketProvider {
  io.Socket? _socket;

  @override
  Future<void> connect(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? options,
  }) async {
    if (_socket != null) {
      return;
    }

    final socketOptions = <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    };

    if (options != null) {
      socketOptions.addAll(options);
    }
    if (headers != null && headers.isNotEmpty) {
      socketOptions['extraHeaders'] = headers;
    }

    final socket = io.io(url, socketOptions);
    _socket = socket;

    final completer = Completer<void>();
    socket.onConnect((_) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });
    socket.onConnectError((error) {
      if (!completer.isCompleted) {
        completer.completeError(
          DSWebSocketError(
            'Socket.IO connection failed.',
            originalError: error,
          ),
        );
      }
    });
    socket.onError((error) {
      if (!completer.isCompleted) {
        completer.completeError(
          DSWebSocketError(
            'Socket.IO connection error.',
            originalError: error,
          ),
        );
      }
    });

    return completer.future;
  }

  @override
  void on(String event, void Function(dynamic data) handler) {
    final socket = _requireSocket();
    socket.on(event, handler);
  }

  @override
  void emit(String event, dynamic data) {
    final socket = _requireSocket();
    socket.emit(event, data);
  }

  @override
  Future<void> disconnect() async {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  @override
  Future<void> dispose() {
    return disconnect();
  }

  io.Socket _requireSocket() {
    final socket = _socket;
    if (socket == null) {
      throw DSWebSocketError('Socket.IO provider is not connected.');
    }
    return socket;
  }
}
