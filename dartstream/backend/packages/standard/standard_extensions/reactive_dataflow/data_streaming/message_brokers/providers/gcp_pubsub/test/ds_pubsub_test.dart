import 'package:ds_tools_testing/ds_tools_testing.dart';
import '../lib//ds_message_broker_gcp_pubsub_export.dart';
import 'package:ds_message_broker_base/ds_message_broker_base_export.dart';

void main() {
  group('DSGcpPubSubMessageBrokerProvider', () {
    late DSGcpPubSubMessageBrokerProvider provider;

    setUp(() {
      provider = DSGcpPubSubMessageBrokerProvider();
    });

    test('throws error if publish is called before initialize', () async {
      expect(
        () => provider.publish('topic', 'payload'),
        throwsA(isA<DSMessageBrokerError>()),
      );
    });

    test('throws error if subscribe is called before initialize', () {
      expect(
        () => provider.subscribe('sub'),
        throwsA(isA<DSMessageBrokerError>()),
      );
    });

    test('throws error if acknowledge is called before initialize', () async {
      expect(
        () => provider.acknowledge('sub', ['ack']),
        throwsA(isA<DSMessageBrokerError>()),
      );
    });

    test('acknowledge returns early if ackIds is empty', () async {
      // Should NOT throw even if not initialized,
      // because method exits before requiring API
      await provider.acknowledge('sub', []);
    });

    test('dispose resets internal state', () async {
      await provider.dispose();

      expect(
        () => provider.publish('topic', 'payload'),
        throwsA(isA<DSMessageBrokerError>()),
      );
    });

    test('initialize throws if projectId missing', () async {
      expect(
        () => provider.initialize({}),
        throwsA(isA<DSMessageBrokerError>()),
      );
    });

    test('initialize throws if credentials missing', () async {
      expect(
        () => provider.initialize({
          'projectId': 'test-project',
        }),
        throwsA(isA<DSMessageBrokerError>()),
      );
    });
  });
}