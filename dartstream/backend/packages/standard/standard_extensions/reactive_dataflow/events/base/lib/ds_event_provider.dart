/// Event provider interface for DartStream.
/// Defines the standard interface for event providers.
abstract class DSEventProvider {
  /// Initialize the provider with configuration settings.
  Future<void> initialize(Map<String, dynamic> config);

  /// Publish an event with a payload.
  Future<void> publish(
    String eventType,
    Map<String, dynamic> payload, {
    Map<String, String>? attributes,
  });

  /// Subscribe to an event stream.
  Stream<DSEventMessage> subscribe(
    String subscription, {
    int maxMessages = 10,
    Duration? pollInterval,
  });

  /// Acknowledge received events.
  Future<void> acknowledge(String subscription, List<String> ackIds);

  /// Dispose of the provider and release resources.
  Future<void> dispose();
}

/// Standard event message.
class DSEventMessage {
  /// Event identifier.
  final String id;

  /// Event type or name.
  final String type;

  /// Event payload.
  final Map<String, dynamic> payload;

  /// Optional attributes/headers.
  final Map<String, String> attributes;

  /// Optional publish timestamp.
  final DateTime? publishTime;

  /// Optional acknowledgement identifier.
  final String? ackId;

  /// Constructor.
  DSEventMessage({
    required this.id,
    required this.type,
    required this.payload,
    this.attributes = const {},
    this.publishTime,
    this.ackId,
  });
}

/// Custom exception for event errors.
class DSEventError implements Exception {
  /// Error message.
  final String message;

  /// Error code.
  final String code;

  /// Native error object.
  final dynamic originalError;

  /// Constructor.
  DSEventError(
    this.message, {
    this.code = 'unknown',
    this.originalError,
  });

  @override
  String toString() => 'DSEventError: $message (Code: $code)';
}
