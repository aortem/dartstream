import 'dart:convert';
import 'package:shelf/shelf.dart';

/// Base class for all Dartstream errors.
abstract class DSError implements Exception {
  final String message;
  final int statusCode;

  DSError(this.message, this.statusCode);

  @override
  String toString() => '$runtimeType: $message (Status: $statusCode)';

  Map<String, dynamic> toJson() => {
        'error': {
          'type': runtimeType.toString(),
          'message': message,
        }
      };
}

/// Thrown when a resource is not found.
class NotFoundError extends DSError {
  NotFoundError(String message) : super(message, 404);
}

/// Thrown when user input is invalid.
class ValidationError extends DSError {
  ValidationError(String message) : super(message, 400);
}

/// Thrown when authentication fails.
class UnauthorizedError extends DSError {
  UnauthorizedError(String message) : super(message, 401);
}

/// Thrown when an operation is forbidden even if authenticated.
class ForbiddenError extends DSError {
  ForbiddenError(String message) : super(message, 403);
}

/// Thrown for internal server errors that can be gracefully handled.
class InternalServerError extends DSError {
  InternalServerError(String message) : super(message, 500);
}

/// Middleware that catches [DSError] and other [Exception]/[Error]s
/// and converts them into appropriate shelf [Response]s.
///
/// [onError] is an optional callback for custom logging.
/// If not provided, it defaults to printing to the console.
Middleware dsErrorMiddleware({void Function(dynamic error, StackTrace stackTrace)? onError}) {
  return (Handler innerHandler) {
    return (Request request) async {
      try {
        return await innerHandler(request);
      } catch (e, stackTrace) {
        if (onError != null) {
          onError(e, stackTrace);
        } else {
          // Simple console logging default
          print('--------------------------------------------------');
          print('[ERROR] ${DateTime.now().toIso8601String()}');
          print('Request: ${request.method} ${request.requestedUri}');
          print('Error: $e');
          print('Stack Trace:\n$stackTrace');
          print('--------------------------------------------------');
        }

        if (e is DSError) {
          return Response(
            e.statusCode,
            body: jsonEncode(e.toJson()),
            headers: {'content-type': 'application/json'},
          );
        }

        // Generic fallback for unhandled exceptions
        return Response.internalServerError(
          body: jsonEncode({
            'error': {
              'type': 'InternalServerError',
              'message': 'An unexpected error occurred.',
            }
          }),
          headers: {'content-type': 'application/json'},
        );
      }
    };
  };
}
