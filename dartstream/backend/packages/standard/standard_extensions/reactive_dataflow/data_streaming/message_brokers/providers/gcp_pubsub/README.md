# DartStream GCP Pub/Sub Message Broker Provider

Google Cloud Pub/Sub provider for DartStream using the official `googleapis` client.

## Install

```yaml
dependencies:
  ds_message_broker_base: ^0.0.1
  ds_gcp_pubsub_message_broker_provider: ^0.0.1
```

## Usage

```dart
import 'package:ds_message_broker_base/ds_message_broker_base_export.dart';
import 'package:ds_gcp_pubsub_message_broker_provider/ds_message_broker_gcp_pubsub_export.dart';

final config = {
  'name': 'pubsub',
  'projectId': 'my-gcp-project',
  'serviceAccountPath': '/path/to/service-account.json',
};

registerGcpPubSubMessageBroker(config);

final broker = DSMessageBrokerManager('pubsub');
await broker.initialize(config);

await broker.publish('topic-name', 'hello world');
```

## Configuration

- `projectId` (required)
- `serviceAccountPath` or `serviceAccount` / `serviceAccountJson` (required)
- `name` (optional, default `pubsub`)

## Notes

- Pub/Sub expects payloads to be UTF-8 strings.
- Subscriptions are polled; tune `pollInterval` and `maxMessages` when subscribing.
