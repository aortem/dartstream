import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ds_message_broker_base/ds_message_broker_base_export.dart';
import 'package:googleapis/pubsub/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

/// Google Cloud Pub/Sub provider for DartStream message brokers.
class DSGcpPubSubMessageBrokerProvider implements DSMessageBrokerProvider {
  bool _initialized = false;
  String? _projectId;
  PubsubApi? _api;
  AutoRefreshingAuthClient? _authClient;

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    if (_initialized) {
      return;
    }

    final projectId = _requireString(config, 'projectId');
    final credentials = _loadCredentials(config);

    final scopes = <String>[
      PubsubApi.cloudPlatformScope,
      PubsubApi.pubsubScope,
    ];

    _authClient = await clientViaServiceAccount(credentials, scopes);
    _api = PubsubApi(_authClient!);
    _projectId = projectId;
    _initialized = true;
  }

  @override
  Future<void> publish(
    String topic,
    String payload, {
    Map<String, String>? attributes,
  }) async {
    final api = _requireApi();
    final topicPath = _topicPath(topic);
    final message = PubsubMessage(
      data: base64Encode(utf8.encode(payload)),
      attributes: attributes,
    );

    await api.projects.topics.publish(
      PublishRequest(messages: [message]),
      topicPath,
    );
  }

  @override
  Stream<DSMessageBrokerMessage> subscribe(
    String subscription, {
    int maxMessages = 10,
    Duration? pollInterval,
  }) {
    final api = _requireApi();
    final subscriptionPath = _subscriptionPath(subscription);
    final interval = pollInterval ?? const Duration(seconds: 2);
    final controller = StreamController<DSMessageBrokerMessage>();
    var active = true;

    controller.onCancel = () {
      active = false;
    };

    () async {
      while (active) {
        try {
          final response = await api.projects.subscriptions.pull(
            PullRequest(
              maxMessages: maxMessages < 1 ? 1 : maxMessages,
            ),
            subscriptionPath,
          );

          final messages = response.receivedMessages ?? const [];
          if (messages.isEmpty) {
            await Future<void>.delayed(interval);
            continue;
          }

          for (final received in messages) {
            final raw = received.message;
            final payload = _decodeData(raw?.data);
            final attributes = raw?.attributes ?? const {};
            final messageId = raw?.messageId ?? '';

            controller.add(
              DSMessageBrokerMessage(
                id: messageId,
                payload: payload,
                attributes: attributes,
                ackId: received.ackId,
              ),
            );
          }
        } catch (error) {
          controller.addError(
            DSMessageBrokerError(
              'Failed to pull messages.',
              originalError: error,
            ),
          );
          await Future<void>.delayed(interval);
        }
      }

      await controller.close();
    }();

    return controller.stream;
  }

  @override
  Future<void> acknowledge(
    String subscription,
    List<String> ackIds,
  ) async {
    if (ackIds.isEmpty) {
      return;
    }
    final api = _requireApi();
    final subscriptionPath = _subscriptionPath(subscription);
    await api.projects.subscriptions.acknowledge(
      AcknowledgeRequest(ackIds: ackIds),
      subscriptionPath,
    );
  }

  @override
  Future<void> dispose() async {
    _api = null;
    _authClient?.close();
    _authClient = null;
    _projectId = null;
    _initialized = false;
  }

  PubsubApi _requireApi() {
    if (!_initialized || _api == null || _projectId == null) {
      throw DSMessageBrokerError('Pub/Sub provider is not initialized.');
    }
    return _api!;
  }

  String _topicPath(String topic) {
    final trimmed = topic.trim();
    if (trimmed.startsWith('projects/')) {
      return trimmed;
    }
    return 'projects/${_projectId!}/topics/$trimmed';
  }

  String _subscriptionPath(String subscription) {
    final trimmed = subscription.trim();
    if (trimmed.startsWith('projects/')) {
      return trimmed;
    }
    return 'projects/${_projectId!}/subscriptions/$trimmed';
  }

  ServiceAccountCredentials _loadCredentials(Map<String, dynamic> config) {
    final raw = config['serviceAccount'] ?? config['serviceAccountJson'];
    if (raw is Map<String, dynamic>) {
      return ServiceAccountCredentials.fromJson(raw);
    }
    if (raw is Map) {
      return ServiceAccountCredentials.fromJson(
        raw.map((key, value) => MapEntry(key.toString(), value)),
      );
    }
    if (raw is String && raw.trim().isNotEmpty) {
      return _credentialsFromString(raw);
    }

    final path = config['serviceAccountPath'];
    if (path is String && path.trim().isNotEmpty) {
      final file = File(path);
      if (!file.existsSync()) {
        throw DSMessageBrokerError('Service account file not found: $path');
      }
      final content = file.readAsStringSync();
      return _credentialsFromString(content);
    }

    throw DSMessageBrokerError(
      'Missing service account credentials. Provide serviceAccountPath or serviceAccount.',
    );
  }

  ServiceAccountCredentials _credentialsFromString(String content) {
    final jsonValue = jsonDecode(content);
    if (jsonValue is Map<String, dynamic>) {
      return ServiceAccountCredentials.fromJson(jsonValue);
    }
    if (jsonValue is Map) {
      return ServiceAccountCredentials.fromJson(
        jsonValue.map((key, value) => MapEntry(key.toString(), value)),
      );
    }
    throw DSMessageBrokerError('Invalid service account JSON.');
  }

  String _decodeData(String? data) {
    if (data == null || data.isEmpty) {
      return '';
    }
    try {
      return utf8.decode(base64Decode(data));
    } catch (_) {
      return '';
    }
  }

  String _requireString(Map<String, dynamic> config, String key) {
    final value = config[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    throw DSMessageBrokerError('Missing required config: $key');
  }
}
