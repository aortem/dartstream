/// Message broker provider interface for DartStream.
/// Defines the standard interface for all message broker providers.
abstract class DSMessageBrokerProvider {
  /// Initialize the provider with configuration settings.
  Future<void> initialize(Map<String, dynamic> config);

  /// Publish a message to a topic.
  Future<void> publish(
    String topic,
    String payload, {
    Map<String, String>? attributes,
  });

  /// Subscribe to a topic or subscription stream.
  Stream<DSMessageBrokerMessage> subscribe(
    String subscription, {
    int maxMessages = 10,
    Duration? pollInterval,
  });

  /// Acknowledge received messages.
  Future<void> acknowledge(
    String subscription,
    List<String> ackIds,
  );

  /// Dispose of the provider and release resources.
  Future<void> dispose();
}

/// Standard message shape returned by message broker providers.
class DSMessageBrokerMessage {
  /// Message identifier.
  final String id;

  /// Message payload (UTF-8 string).
  final String payload;

  /// Optional attributes/headers.
  final Map<String, String> attributes;

  /// Optional publish timestamp.
  final DateTime? publishTime;

  /// Optional acknowledgement identifier.
  final String? ackId;

  /// Constructor.
  DSMessageBrokerMessage({
    required this.id,
    required this.payload,
    this.attributes = const {},
    this.publishTime,
    this.ackId,
  });
}

/// Custom exception for message broker errors.
class DSMessageBrokerError implements Exception {
  /// Error message.
  final String message;

  /// Error code.
  final String code;

  /// Native error object.
  final dynamic originalError;

  /// Constructor.
  DSMessageBrokerError(
    this.message, {
    this.code = 'unknown',
    this.originalError,
  });

  @override
  String toString() => 'DSMessageBrokerError: $message (Code: $code)';
}
