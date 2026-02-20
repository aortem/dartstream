import 'dart:async';
import 'dart:io';
import '../../app/models/ds_custom_middleware_model.dart';

class DsWebSocketHandler {
  final Set<WebSocket> _sockets = {};

  Future<DsCustomMiddleWareResponse> handleRequest(
    DsCustomMiddleWareRequest request,
  ) async {
    // Note: We need a way to access the underlying HttpRequest to use WebSocketTransformer.
    // Assuming the request object or context provides this in a real integration.
    // For now, this is a placeholder for the logic.
    return DsCustomMiddleWareResponse.notFound();
  }

  // ignore: unused_element
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
