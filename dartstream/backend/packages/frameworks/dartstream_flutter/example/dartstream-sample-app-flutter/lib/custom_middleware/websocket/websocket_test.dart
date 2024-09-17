import 'dart:async';

class MockWebSocket {
  final StreamController<String> _controller =
      StreamController<String>.broadcast();
  int messageCount = 0;
  static const int MAX_MESSAGES = 5;

  Stream<String> get stream => _controller.stream;
  StreamSink<String> get sink => _controller.sink;

  void close() {
    _controller.close();
  }

  void add(String message) {
    if (messageCount < MAX_MESSAGES) {
      _controller.add(message);
      messageCount++;
    } else if (messageCount == MAX_MESSAGES) {
      _controller.add("Max messages reached. Closing connection.");
      messageCount++;
      close();
    }
  }
}

class MockWebSocketServer {
  MockWebSocket connect() {
    final socket = MockWebSocket();
    socket.stream.listen((message) {
      // Echo the message back
      socket.add('Server received: $message');
    });
    return socket;
  }
}

Future<String> testWebSocket() async {
  final server = MockWebSocketServer();
  final socket = server.connect();
  List<String> receivedMessages = [];

  try {
    socket.stream.listen(
      (message) {
        print('Received: $message');
        receivedMessages.add(message);
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket connection closed');
      },
    );

    socket.sink.add('Hello, WebSocket!');

    await Future.delayed(Duration(seconds: 2));

    socket.close();

    return 'Mock WebSocket test completed. Messages:\n${receivedMessages.join("\n")}';
  } catch (e) {
    return 'Mock WebSocket test failed: $e';
  }
}
