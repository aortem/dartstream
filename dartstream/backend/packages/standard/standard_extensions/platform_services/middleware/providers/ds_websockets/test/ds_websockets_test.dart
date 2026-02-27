import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:ds_shelf/ds_shelf.dart' as ds;
import 'package:ds_websockets/ds_websockets.dart';
import 'package:stream_channel/stream_channel.dart';
import 'dart:convert';

void main() {
  group('DSWebSocketHandler', () {
    test('Can be initialized', () {
      final wsHandler = DSWebSocketHandler();
      expect(wsHandler, isNotNull);
      expect(wsHandler.connectionCount, equals(0));
    });

    test('Handler property returns a Shelf Handler', () {
      final wsHandler = DSWebSocketHandler();
      expect(wsHandler.handler, isA<ds.Handler>());
    });
  });

  group('Adapters', () {
    // Note: Full integration testing with mock channels would be more complex,
    // but we can test the basic adapter logic if we mock the stream.
  });

  group('Socket.IO Adapter', () {
    test('Processes incoming JSON events', () async {
      // Create a mock controller for the stream
      final controller = StreamChannelController<String>();
      final adapter = DSSocketIoAdapter(controller.foreign);

      bool eventHandled = false;
      adapter.on('test-event', (data) {
        expect(data, equals('test-data'));
        eventHandled = true;
      });

      // Simulate incoming data
      controller.local.sink.add(jsonEncode({
        'event': 'test-event',
        'data': 'test-data'
      }));

      // Give it a moment to process
      await Future.delayed(Duration(milliseconds: 10));
      expect(eventHandled, isTrue);
    });

    test('Emits outgoing JSON events', () async {
      final controller = StreamChannelController<String>();
      final adapter = DSSocketIoAdapter(controller.foreign);

      adapter.emit('out-event', {'key': 'value'});

      final received = await controller.local.stream.first;
      final decoded = jsonDecode(received);
      expect(decoded['event'], equals('out-event'));
      expect(decoded['data']['key'], equals('value'));
    });
  });

  group('Soketi Adapter', () {
    test('Emits connection established event on creation', () async {
      final controller = StreamChannelController<String>();
      DSSoketiAdapter(controller.foreign);

      final received = await controller.local.stream.first;
      final decoded = jsonDecode(received);
      expect(decoded['event'], equals('pusher:connection_established'));
    });

    test('Processes incoming events', () async {
      final controller = StreamChannelController<String>();
      final adapter = DSSoketiAdapter(controller.foreign);

      bool eventHandled = false;
      adapter.on('client-msg', (data) {
        expect(data['text'], equals('hello'));
        eventHandled = true;
      });

      controller.local.sink.add(jsonEncode({
        'event': 'client-msg',
        'data': {'text': 'hello'}
      }));

      await Future.delayed(Duration(milliseconds: 10));
      expect(eventHandled, isTrue);
    });
  });
}
