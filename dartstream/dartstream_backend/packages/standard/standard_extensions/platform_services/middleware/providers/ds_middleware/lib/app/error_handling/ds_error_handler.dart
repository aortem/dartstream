import 'dart:convert';
import '../models/ds_custom_middleware_model.dart';

class DsErrorHandler {
  final Map<Type, int> _statusCodes = {
    NotFoundException: 404,
    UnauthorizedException: 401,
    ForbiddenException: 403,
    ValidationException: 422,
  };

  Future<DsCustomMiddleWareResponse> handle(
    DsCustomMiddleWareRequest request,
    Future<DsCustomMiddleWareResponse> Function(DsCustomMiddleWareRequest) next,
  ) async {
    try {
      return await next(request);
    } catch (e) {
      return _handleException(e);
    }
  }

  DsCustomMiddleWareResponse _handleException(dynamic exception) {
    final statusCode = _getStatusCode(exception);
    final message = exception.toString();

    // Log the error here

    return DsCustomMiddleWareResponse(
      statusCode,
      {'Content-Type': 'application/json'},
      jsonEncode({
        'error': {
          'message': message,
          'statusCode': statusCode,
        }
      }),
    );
  }

  int _getStatusCode(dynamic exception) {
    return _statusCodes[exception.runtimeType] ?? 500;
  }
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
  @override
  String toString() => message;
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
  @override
  String toString() => message;
}

class ForbiddenException implements Exception {
  final String message;
  ForbiddenException(this.message);
  @override
  String toString() => message;
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
  @override
  String toString() => message;
}
