import 'dart:async';
import 'dart:io';
import '../../app/models/ds_custom_middleware_model.dart';

class DsWebSocketHandler {
  final Set<WebSocket> _sockets = {};

  Future<DsCustomMiddleWareResponse> handleRequest(
      DsCustomMiddleWareRequest request) async {
    final httpRequest = request.context['shelf.io.http_request'];

    if (httpRequest is HttpRequest &&
        WebSocketTransformer.isUpgradeRequest(httpRequest)) {
      final socket = await WebSocketTransformer.upgrade(httpRequest);
      _handleWebSocket(socket);
      return DsCustomMiddleWareResponse(101, {}, 'Switching Protocols');
    } else {
      return DsCustomMiddleWareResponse.notFound();
    }
  }

  void _handleWebSocket(WebSocket socket) {
    _sockets.add(socket);

    socket.listen(
      (message) {
        _broadcast(message, socket);
      },
      onDone: () {
        _sockets.remove(socket);
      },
      onError: (error) {
        print('WebSocket error: $error');
        _sockets.remove(socket);
      },
    );
  }

  void _broadcast(String message, WebSocket sender) {
    for (var socket in _sockets) {
      if (socket != sender) {
        socket.add(message);
      }
    }
  }
}
