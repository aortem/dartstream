import 'dart:convert';

import 'package:ds_feature_flags_base/ds_feature_flag_provider.dart';
import 'package:http/http.dart' as http;

import 'src/ds_flagd_error_mapper.dart';

class DSFlagdProvider implements DSFeatureFlagProvider {
  DSFlagdProvider({
    required this.baseUri,
    http.Client? client,
    this.requestTimeout = const Duration(seconds: 5),
  }) : _client = client ?? http.Client();

  final Uri baseUri;
  final http.Client _client;
  final Duration requestTimeout;

  Uri _resolveUri(String flagKey) {
    final normalizedPath = baseUri.path.endsWith('/')
        ? '${baseUri.path}$flagKey'
        : '${baseUri.path}/$flagKey';
    return baseUri.replace(path: normalizedPath);
  }

  Future<Map<String, dynamic>> _evaluate(
    String flagKey, {
    required dynamic defaultValue,
    Map<String, dynamic>? context,
  }) async {
    final payload = <String, dynamic>{
      'context': context ?? <String, dynamic>{},
      'defaultValue': defaultValue,
    };

    try {
      final response = await _client
          .post(
            _resolveUri(flagKey),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(requestTimeout);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw DSFlagdException(
          code: 'http_error',
          message:
              'flagd request failed with status ${response.statusCode}: ${response.body}',
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const DSFlagdException(
          code: 'invalid_response',
          message: 'flagd returned a non-object response',
        );
      }
      return decoded;
    } catch (e) {
      throw DSFlagdErrorMapper.mapError(e);
    }
  }

  static T _coerce<T>(dynamic value, T fallback) {
    if (value is T) return value;
    if (T == num && value is int) return value as T;
    return fallback;
  }

  @override
  Future<bool> getBooleanFlag(
    String flagKey, {
    bool defaultValue = false,
    Map<String, dynamic>? context,
  }) async {
    final result = await _evaluate(
      flagKey,
      defaultValue: defaultValue,
      context: context,
    );
    return _coerce<bool>(result['value'], defaultValue);
  }

  @override
  Future<String> getStringFlag(
    String flagKey, {
    String defaultValue = '',
    Map<String, dynamic>? context,
  }) async {
    final result = await _evaluate(
      flagKey,
      defaultValue: defaultValue,
      context: context,
    );
    return _coerce<String>(result['value'], defaultValue);
  }

  @override
  Future<num> getNumberFlag(
    String flagKey, {
    num defaultValue = 0,
    Map<String, dynamic>? context,
  }) async {
    final result = await _evaluate(
      flagKey,
      defaultValue: defaultValue,
      context: context,
    );
    return _coerce<num>(result['value'], defaultValue);
  }

  @override
  Future<Map<String, dynamic>> getJsonFlag(
    String flagKey, {
    Map<String, dynamic> defaultValue = const {},
    Map<String, dynamic>? context,
  }) async {
    final result = await _evaluate(
      flagKey,
      defaultValue: defaultValue,
      context: context,
    );
    return _coerce<Map<String, dynamic>>(result['value'], defaultValue);
  }

  @override
  Future<DSFeatureFlagEvaluationResult> evaluateFlag(
    String flagKey, {
    Map<String, dynamic>? context,
  }) async {
    final result = await _evaluate(
      flagKey,
      defaultValue: false,
      context: context,
    );
    return DSFeatureFlagEvaluationResult(
      value: result['value'] ?? false,
      reason: (result['reason'] ?? 'unknown').toString(),
      variant: (result['variant'] ?? '').toString(),
    );
  }
}
