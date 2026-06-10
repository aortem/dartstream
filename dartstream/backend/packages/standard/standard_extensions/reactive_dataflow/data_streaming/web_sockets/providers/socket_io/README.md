# DartStream Socket.IO WebSocket Provider

Socket.IO provider for DartStream using the `socket_io_client` package.

## Install

```yaml
dependencies:
  ds_websocket_base: ^0.0.1
  ds_socket_io_websocket_provider: ^0.0.2
```

## Usage

```dart
import 'package:ds_websocket_base/ds_websocket_base_export.dart';
import 'package:ds_socket_io_websocket_provider/ds_websocket_socket_io_export.dart';

final config = {
  'name': 'socketio',
};

registerSocketIoWebSocketProvider(config);

final socket = DSWebSocketManager('socketio');
await socket.connect('https://example.com', options: {
  'transports': ['websocket'],
});

socket.on('message', (data) {
  print('Received: $data');
});

socket.emit('message', {'hello': 'world'});
```

## Configuration

- `name` (optional, default `socketio`)
- `headers` (optional, passed via `extraHeaders`)
- `options` (optional, passed to `socket_io_client`)
