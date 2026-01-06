import 'dart:async';
import 'dart:io';
import '../models/ds_custom_middleware_model.dart';

class DsWebSocketHandler {
  final Set<WebSocket> _sockets = {};

  Future<DsCustomMiddleWareResponse> handle(
      DsCustomMiddleWareRequest request) async {
    if (!_isWebSocketUpgradeRequest(request)) {
      return DsCustomMiddleWareResponse(
          400, {}, 'Not a WebSocket upgrade request');
    }

    final socket = await _upgradeToWebSocket(request);
    _sockets.add(socket);

    socket.listen(
      (message) => _handleMessage(socket, message),
      onDone: () => _handleDisconnect(socket),
      onError: (error) => _handleError(socket, error),
    );

    // Return a response to indicate successful upgrade
    return DsCustomMiddleWareResponse(101, {}, '');
  }

  bool _isWebSocketUpgradeRequest(DsCustomMiddleWareRequest request) {
    var connection = request.headers['connection'];
    var upgrade = request.headers['upgrade'];
    return connection?.toLowerCase().contains('upgrade') == true &&
        upgrade?.toLowerCase() == 'websocket';
  }

  Future<WebSocket> _upgradeToWebSocket(
      DsCustomMiddleWareRequest request) async {
    var socket = await WebSocket.connect(
        'ws://${request.uri.authority}${request.uri.path}');
    return socket;
  }

  void _handleMessage(WebSocket socket, dynamic message) {
    // Process the message and potentially broadcast to other clients
    for (var client in _sockets) {
      if (client != socket) {
        client.add(message);
      }
    }
  }

  void _handleDisconnect(WebSocket socket) {
    _sockets.remove(socket);
  }

  void _handleError(WebSocket socket, dynamic error) {
    print('WebSocket error: $error');
    _sockets.remove(socket);
  }

  void broadcast(String message) {
    for (var socket in _sockets) {
      socket.add(message);
    }
  }
}
