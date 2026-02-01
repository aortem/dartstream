import 'dart:convert';
import 'dart:io';

import 'package:ds_logging_base/ds_logging_base_export.dart';

class DSOtlpLoggingProvider implements DSLoggingProvider {
  bool _initialized = false;
  late Uri _endpoint;
  Duration _timeout = const Duration(seconds: 2);
  String? _serviceName;
  String? _serviceVersion;
  String? _environment;
  Map<String, String> _headers = {};
  Map<String, String> _resourceAttributes = {};

  final List<Future<void>> _pending = [];

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    final endpoint = config['endpoint'] ?? config['url'];
    if (endpoint is String && endpoint.trim().isNotEmpty) {
      _endpoint = Uri.parse(endpoint.trim());
    } else if (endpoint is Uri) {
      _endpoint = endpoint;
    } else {
      throw ArgumentError('OpenTelemetry endpoint is required.');
    }

    _headers = _stringMap(config['headers']);
    _resourceAttributes = _stringMap(config['resourceAttributes']);

    _serviceName = _stringValue(config['serviceName']);
    _serviceVersion = _stringValue(config['serviceVersion']);
    _environment = _stringValue(config['environment']);

    final timeoutValue = config['timeout'];
    if (timeoutValue is Duration) {
      _timeout = timeoutValue;
    } else if (timeoutValue is int) {
      _timeout = Duration(seconds: timeoutValue);
    } else if (timeoutValue is num) {
      _timeout = Duration(seconds: timeoutValue.round());
    }

    _initialized = true;
  }

  @override
  void info(String message, {Map<String, dynamic>? context}) {
    _enqueue(
      message,
      severityText: 'INFO',
      severityNumber: 9,
      context: context,
    );
  }

  @override
  void warn(String message, {Map<String, dynamic>? context}) {
    _enqueue(
      message,
      severityText: 'WARN',
      severityNumber: 13,
      context: context,
    );
  }

  @override
  void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    final mergedContext = <String, dynamic>{};
    if (context != null) {
      mergedContext.addAll(context);
    }
    if (error != null) {
      mergedContext['error.message'] = error.toString();
    }
    if (stackTrace != null) {
      mergedContext['error.stacktrace'] = stackTrace.toString();
    }

    _enqueue(
      message,
      severityText: 'ERROR',
      severityNumber: 17,
      context: mergedContext,
    );
  }

  void _enqueue(
    String message, {
    required String severityText,
    required int severityNumber,
    Map<String, dynamic>? context,
  }) {
    if (!_initialized) {
      return;
    }

    final payload = _buildPayload(
      message,
      severityText: severityText,
      severityNumber: severityNumber,
      context: context,
    );

    _track(_post(payload));
  }

  Future<void> _post(Map<String, dynamic> payload) async {
    final client = HttpClient();
    try {
      final request = await client.postUrl(_endpoint).timeout(_timeout);
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      _headers.forEach((key, value) {
        request.headers.set(key, value);
      });
      request.write(jsonEncode(payload));

      final response = await request.close().timeout(_timeout);
      await response.drain();
    } catch (_) {
      // Swallow transport errors; logging must not crash the app.
    } finally {
      client.close();
    }
  }

  Map<String, dynamic> _buildPayload(
    String message, {
    required String severityText,
    required int severityNumber,
    Map<String, dynamic>? context,
  }) {
    final logRecord = <String, dynamic>{
      'timeUnixNano': _toUnixNano(DateTime.now().toUtc()),
      'severityNumber': severityNumber,
      'severityText': severityText,
      'body': {'stringValue': message},
    };

    final attributes = _mapAttributes(context);
    if (attributes.isNotEmpty) {
      logRecord['attributes'] = attributes;
    }

    return {
      'resourceLogs': [
        {
          'resource': _buildResource(),
          'scopeLogs': [
            {
              'scope': {'name': 'dartstream.logging'},
              'logRecords': [logRecord],
            }
          ],
        }
      ]
    };
  }

  Map<String, dynamic> _buildResource() {
    final attributes = <Map<String, dynamic>>[];

    if (_serviceName != null && _serviceName!.isNotEmpty) {
      attributes.add(_kv('service.name', _serviceName));
    }

    if (_serviceVersion != null && _serviceVersion!.isNotEmpty) {
      attributes.add(_kv('service.version', _serviceVersion));
    }

    if (_environment != null && _environment!.isNotEmpty) {
      attributes.add(_kv('deployment.environment', _environment));
    }

    _resourceAttributes.forEach((key, value) {
      attributes.add(_kv(key, value));
    });

    if (attributes.isEmpty) {
      return {};
    }

    return {'attributes': attributes};
  }

  List<Map<String, dynamic>> _mapAttributes(Map<String, dynamic>? context) {
    if (context == null || context.isEmpty) {
      return [];
    }

    final attributes = <Map<String, dynamic>>[];
    context.forEach((key, value) {
      final anyValue = _toAnyValue(value);
      if (anyValue != null) {
        attributes.add({'key': key, 'value': anyValue});
      }
    });

    return attributes;
  }

  Map<String, dynamic> _kv(String key, Object? value) {
    return {'key': key, 'value': _toAnyValue(value) ?? {'stringValue': ''}};
  }

  Map<String, dynamic>? _toAnyValue(Object? value) {
    if (value == null) return null;

    if (value is bool) {
      return {'boolValue': value};
    }

    if (value is int) {
      return {'intValue': value};
    }

    if (value is double) {
      return {'doubleValue': value};
    }

    if (value is num) {
      return {'doubleValue': value.toDouble()};
    }

    if (value is String) {
      return {'stringValue': value};
    }

    if (value is Iterable) {
      final values = value
          .map(_toAnyValue)
          .whereType<Map<String, dynamic>>()
          .toList();
      return {
        'arrayValue': {
          'values': values,
        }
      };
    }

    return {'stringValue': value.toString()};
  }

  String _toUnixNano(DateTime timestamp) {
    final micros = BigInt.from(timestamp.microsecondsSinceEpoch);
    return (micros * BigInt.from(1000)).toString();
  }

  Map<String, String> _stringMap(dynamic raw) {
    if (raw is Map) {
      return raw.map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      );
    }
    return {};
  }

  String? _stringValue(dynamic value) {
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return null;
  }

  void _track(Future<void> future) {
    _pending.add(future);
    future.whenComplete(() => _pending.remove(future));
  }

  @override
  Future<void> flush() async {
    if (_pending.isEmpty) {
      return;
    }
    final pending = List<Future<void>>.from(_pending);
    try {
      await Future.wait(pending).timeout(_timeout);
    } catch (_) {
      // Swallow flush failures.
    }
  }

  @override
  Future<void> dispose() async {
    await flush();
    _initialized = false;
  }
}
