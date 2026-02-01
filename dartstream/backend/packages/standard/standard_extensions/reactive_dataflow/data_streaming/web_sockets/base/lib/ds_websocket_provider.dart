/// WebSocket provider interface for DartStream.
/// Defines the standard interface for all WebSocket providers.
abstract class DSWebSocketProvider {
  /// Connect to a WebSocket endpoint.
  Future<void> connect(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? options,
  });

  /// Register an event listener.
  void on(String event, void Function(dynamic data) handler);

  /// Emit an event with optional data.
  void emit(String event, dynamic data);

  /// Disconnect the provider.
  Future<void> disconnect();

  /// Dispose of the provider and release resources.
  Future<void> dispose();
}

/// Custom exception for WebSocket errors.
class DSWebSocketError implements Exception {
  /// Error message.
  final String message;

  /// Error code.
  final String code;

  /// Native error object.
  final dynamic originalError;

  /// Constructor.
  DSWebSocketError(
    this.message, {
    this.code = 'unknown',
    this.originalError,
  });

  @override
  String toString() => 'DSWebSocketError: $message (Code: $code)';
}
