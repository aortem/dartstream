import 'package:web_socket_channel/web_socket_channel.dart';

Future<String> testWebSocket() async {
  final channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8080/ws'));

  channel.sink.add('Hello, WebSocket!');

  final response = await channel.stream.first;

  await channel.sink.close();

  return 'WebSocket test completed. Response: $response';
}
