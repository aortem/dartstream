
void main() async {
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );
}
