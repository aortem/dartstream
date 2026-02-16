import 'package:ds_websocket_base/ds_websocket_base_export.dart';

import 'ds_websocket_socket_io_provider.dart';

String _providerName(Map<String, dynamic> config, String fallback) {
  final value = config['name'];
  if (value is String && value.trim().isNotEmpty) {
    return value.trim();
  }
  return fallback;
}

void registerSocketIoWebSocketProvider(Map<String, dynamic> config) {
  final provider = DSSocketIoWebSocketProvider();

  DSWebSocketManager.registerProvider(
    _providerName(config, 'socketio'),
    provider,
    DSWebSocketProviderMetadata(
      type: 'socket_io',
      vendor: 'socket.io',
      protocol: 'websocket',
      additionalMetadata: {
        if (config['url'] != null) 'url': config['url'],
      },
    ),
  );
}
