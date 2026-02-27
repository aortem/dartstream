import 'dart:io';
import 'dart:convert';
import 'package:ds_shelf/ds_shelf.dart';
import 'package:ds_websockets/ds_websockets.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void main() async {
  print('✨ Starting DartStream Premium WebSocket Demo ✨');

  final server = DSShelfCore();
  
  // 1. Initialize WebSocket Handler
  late final DSWebSocketHandler wsHandler;
  wsHandler = DSWebSocketHandler(
    onConnection: (channel, protocol) {
      final socketId = 'user_${DateTime.now().millisecondsSinceEpoch % 10000}';
      print('🔗 New connection: $socketId (Protocol: $protocol)');
      
      final io = DSSocketIoAdapter(channel);
      
      // Welcome message
      io.emit('system', {
        'message': 'Welcome to DartStream Chat!',
        'userId': socketId,
        'timestamp': DateTime.now().toIso8601String()
      });

      // Notify others
      wsHandler.broadcast(jsonEncode({
        'event': 'system',
        'data': {
          'message': '$socketId joined the room',
          'type': 'join'
        }
      }));

      io.on('chat', (data) {
        print('💬 [$socketId]: $data');
        // Broadcast to everyone including sender for simplicity in UI
        wsHandler.broadcast(jsonEncode({
          'event': 'chat',
          'data': {
            'user': socketId,
            'message': data,
            'timestamp': DateTime.now().toIso8601String()
          }
        }));
      });

      // Handle disconnection via bridge or underlying channel
      // In a real app, we'd add onDone to the channel stream
    },
  );

  // 2. Register WebSocket Route
  server.addWebSocketRoute('/ws', wsHandler.handler);

  // 3. Register Static Files
  String staticPath = 'example/public';
  if (!Directory(staticPath).existsSync()) {
    staticPath = 'public';
  }
  server.addStaticRoute(staticPath);

  // 4. Start Server
  final port = 8081;
  await shelf_io.serve(server.handler, InternetAddress.loopbackIPv4, port);

  print('\n🚀 Server live at http://localhost:$port');
  print('💡 Open multiple browser tabs to test the real-time chat!');
}
