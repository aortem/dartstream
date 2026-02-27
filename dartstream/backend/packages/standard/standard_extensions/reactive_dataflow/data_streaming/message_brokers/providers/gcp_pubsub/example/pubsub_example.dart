import 'dart:async';

import 'package:ds_message_broker_base/ds_message_broker_base_export.dart';
import 'package:ds_gcp_pubsub_message_broker_provider/ds_message_broker_gcp_pubsub_export.dart';

Future<void> main() async {
  // STEP 1: Register the provider
  registerGcpPubSubMessageBroker({
    'name': 'pubsub',
    'projectId': 'YOUR_PROJECT_ID',
    'serviceAccountPath': 'service_account.json',
  });

  // STEP 2: Get provider from manager
  final broker = DSMessageBrokerManager.getProvider('pubsub');

  // STEP 3: Initialize
  await broker?.initialize({
    'projectId': 'YOUR_PROJECT_ID',
    'serviceAccountPath': 'service_account.json',
  });

  const topic = 'dartstream-test-topic';
  const subscription = 'dartstream-test-sub';

  print('Publishing message...');
  await broker.publish(topic, 'Hello from DartStream!');

  print('Listening for messages...');

  final subscriptionStream = broker.subscribe(subscription);

  late StreamSubscription sub;

  sub = subscriptionStream.listen((message) async {
    print('Received: ${message.payload}');

    if (message.ackId != null) {
      await broker.acknowledge(subscription, [message.ackId!]);
      print('Acknowledged message.');
    }

    await sub.cancel();
    await broker?.dispose();
  });
}

extension on Object? {
  Future<void> initialize(Map<String, String> map) async {}
  
  Future<void> dispose() async {}
  
  Future<void> acknowledge(String subscription, List<dynamic> list) async {}
  
  // ignore: body_might_complete_normally_nullable
  Object? subscribe(String subscription) {}
  
  StreamSubscription<dynamic> listen(Future<Null> Function(message) param0) {
    throw UnimplementedError();
  }
  
  Future<void> publish(String topic, String s) async {}
}

class message {
  get ackId => null;
  
  get payload => null;
}