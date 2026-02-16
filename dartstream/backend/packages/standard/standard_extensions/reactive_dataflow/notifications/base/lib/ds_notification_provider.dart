/// Notification provider interface for DartStream.
/// Defines the standard interface for notification providers.
abstract class DSNotificationProvider {
  /// Initialize the provider with configuration settings.
  Future<void> initialize(Map<String, dynamic> config);

  /// Send a notification.
  Future<void> send(DSNotificationRequest request);

  /// Dispose of the provider and release resources.
  Future<void> dispose();
}

/// Notification request payload.
class DSNotificationRequest {
  /// Target channel/topic/user.
  final String target;

  /// Notification title.
  final String title;

  /// Notification body.
  final String body;

  /// Optional data payload.
  final Map<String, dynamic>? data;

  /// Optional attributes/headers.
  final Map<String, String>? attributes;

  /// Constructor.
  DSNotificationRequest({
    required this.target,
    required this.title,
    required this.body,
    this.data,
    this.attributes,
  });
}

/// Custom exception for notification errors.
class DSNotificationError implements Exception {
  /// Error message.
  final String message;

  /// Error code.
  final String code;

  /// Native error object.
  final dynamic originalError;

  /// Constructor.
  DSNotificationError(
    this.message, {
    this.code = 'unknown',
    this.originalError,
  });

  @override
  String toString() => 'DSNotificationError: $message (Code: $code)';
}
