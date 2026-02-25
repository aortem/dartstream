import '../../app/models/ds_custom_middleware_model.dart';

class DsQueryStringHandler {
  /// Sanitize string input (basic example)
  String sanitize(String input) {
    return input.replaceAll(RegExp(r'[<>"]'), '').trim();
  }

  /// Get string safely
  String getString(DsCustomMiddleWareRequest request, String key, {String defaultValue = ''}) {
    final value = request.queryParams[key];
    return value != null ? sanitize(value) : defaultValue;
  }

  /// Get int safely
  int getInt(DsCustomMiddleWareRequest request, String key, {int defaultValue = 0}) {
    final value = request.queryParams[key];
    return value != null ? int.tryParse(value) ?? defaultValue : defaultValue;
  }

  /// Get double safely
  double getDouble(DsCustomMiddleWareRequest request, String key, {double defaultValue = 0.0}) {
    final value = request.queryParams[key];
    return value != null ? double.tryParse(value) ?? defaultValue : defaultValue;
  }

  /// Get bool safely
  bool getBool(DsCustomMiddleWareRequest request, String key, {bool defaultValue = false}) {
    final value = request.queryParams[key]?.toLowerCase();
    if (value == 'true') return true;
    if (value == 'false') return false;
    return defaultValue;
  }

  /// Check if key exists
  bool hasKey(DsCustomMiddleWareRequest request, String key) {
    return request.queryParams.containsKey(key);
  }

  /// Attach parsed query params to the request
  DsCustomMiddleWareRequest attachToRequest(DsCustomMiddleWareRequest request) {
    return request.copyWith(queryParams: request.uri.queryParameters);
  }
}