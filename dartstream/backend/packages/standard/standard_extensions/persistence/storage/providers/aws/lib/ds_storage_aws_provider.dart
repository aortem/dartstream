import 'dart:typed_data';

import 'package:ds_storage_base/ds_storage_base_export.dart';
import 'package:minio/minio.dart';

class DSAwsStorageProvider implements DSStorageProvider {
  bool _initialized = false;
  late Minio _client;
  String? _defaultBucket;
  late String _endPoint;
  late bool _useSSL;
  late int _port;
  bool _pathStyle = true;
  String? _publicBaseUrl;

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    if (_initialized) {
      return;
    }

    _endPoint = _requireString(config, ['endPoint', 'endpoint', 'host']);
    final accessKey = _requireString(config, ['accessKey', 'access_key', 'key']);
    final secretKey =
        _requireString(config, ['secretKey', 'secret_key', 'secret']);

    _useSSL = _boolValue(config, 'useSSL') ??
        _boolValue(config, 'ssl') ??
        _boolValue(config, 'tls') ??
        true;
    _port = _intValue(config, 'port') ?? (_useSSL ? 443 : 80);

    _pathStyle = _boolValue(config, 'pathStyle') ??
        !_endPoint.toLowerCase().contains('amazonaws.com');

    _defaultBucket = _stringValue(config, 'bucket') ??
        _stringValue(config, 'defaultBucket');

    _publicBaseUrl = _stringValue(config, 'publicUrl') ??
        _stringValue(config, 'baseUrl');

    _client = Minio(
      endPoint: _endPoint,
      port: _port,
      useSSL: _useSSL,
      accessKey: accessKey,
      secretKey: secretKey,
      sessionToken: _stringValue(config, 'sessionToken'),
      region: _stringValue(config, 'region'),
      pathStyle: _pathStyle,
      enableTrace: _boolValue(config, 'enableTrace') ?? false,
    );

    final ensureBucket = _boolValue(config, 'ensureBucket') ?? false;
    if (ensureBucket && _defaultBucket != null) {
      final exists = await _client.bucketExists(_defaultBucket!);
      if (!exists) {
        await _client.makeBucket(_defaultBucket!);
      }
    }

    _initialized = true;
  }

  @override
  Future<String> uploadFile(
    String path,
    List<int> data, {
    Map<String, dynamic>? metadata,
  }) async {
    final target = _resolveTarget(path);
    final stream = Stream<Uint8List>.fromIterable([
      Uint8List.fromList(data),
    ]);

    await _client.putObject(
      target.bucket,
      target.object,
      stream,
      size: data.length,
      metadata: _stringMap(metadata),
    );

    return _buildObjectUrl(target.bucket, target.object);
  }

  @override
  Future<List<int>> downloadFile(String path) async {
    final target = _resolveTarget(path);
    final response = await _client.getObject(target.bucket, target.object);
    final bytes = <int>[];
    await for (final chunk in response) {
      bytes.addAll(chunk);
    }
    return bytes;
  }

  @override
  Future<void> deleteFile(String path) async {
    final target = _resolveTarget(path);
    await _client.removeObject(target.bucket, target.object);
  }

  @override
  Future<List<String>> listFiles(String path, {bool recursive = false}) async {
    final target = _resolveTarget(path, allowEmptyObject: true);
    final result = await _client.listAllObjects(
      target.bucket,
      prefix: target.object,
      recursive: recursive,
    );

    return result.objects
        .map((object) => object.key ?? '')
        .where((key) => key.isNotEmpty)
        .toList();
  }

  @override
  Future<String> getSignedUrl(String path, {Duration? expiry}) async {
    final target = _resolveTarget(path);
    return _client.presignedGetObject(
      target.bucket,
      target.object,
      expires: expiry?.inSeconds,
    );
  }

  @override
  Future<void> dispose() async {
    _initialized = false;
  }

  _StorageTarget _resolveTarget(String path, {bool allowEmptyObject = false}) {
    final trimmed = path.trim().replaceAll(RegExp(r'^/+'), '');
    if (_defaultBucket != null && _defaultBucket!.isNotEmpty) {
      if (!allowEmptyObject && trimmed.isEmpty) {
        throw ArgumentError('Object path is required.');
      }
      return _StorageTarget(_defaultBucket!, trimmed);
    }

    final segments = trimmed.split('/');
    if (segments.length < 2) {
      throw ArgumentError('Path must include bucket and object (bucket/object).');
    }

    final bucket = segments.first;
    final object = segments.skip(1).join('/');
    if (!allowEmptyObject && object.isEmpty) {
      throw ArgumentError('Object path is required.');
    }

    return _StorageTarget(bucket, object);
  }

  String _buildObjectUrl(String bucket, String object) {
    if (_publicBaseUrl != null && _publicBaseUrl!.trim().isNotEmpty) {
      return _joinUrl(_publicBaseUrl!, object);
    }

    final scheme = _useSSL ? 'https' : 'http';
    final portPart = (_useSSL && _port == 443) || (!_useSSL && _port == 80)
        ? ''
        : ':$_port';
    final encodedObject = _encodePath(object);

    if (_pathStyle) {
      return '$scheme://$_endPoint$portPart/$bucket/$encodedObject';
    }

    return '$scheme://$bucket.$_endPoint$portPart/$encodedObject';
  }

  String _joinUrl(String baseUrl, String path) {
    final trimmedBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final trimmedPath = path.startsWith('/') ? path.substring(1) : path;
    return '$trimmedBase/$trimmedPath';
  }

  String _encodePath(String path) {
    return path
        .split('/')
        .map((segment) => Uri.encodeComponent(segment))
        .join('/');
  }

  String _requireString(Map<String, dynamic> config, List<String> keys) {
    for (final key in keys) {
      final value = config[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    throw ArgumentError('Missing required config: ${keys.first}');
  }

  String? _stringValue(Map<String, dynamic> config, String key) {
    final value = config[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return null;
  }

  bool? _boolValue(Map<String, dynamic> config, String key) {
    final value = config[key];
    if (value is bool) {
      return value;
    }
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return null;
  }

  int? _intValue(Map<String, dynamic> config, String key) {
    final value = config[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  Map<String, String>? _stringMap(Map<String, dynamic>? metadata) {
    if (metadata == null || metadata.isEmpty) {
      return null;
    }
    return metadata.map(
      (key, value) => MapEntry(key, value.toString()),
    );
  }
}

class _StorageTarget {
  final String bucket;
  final String object;

  _StorageTarget(this.bucket, this.object);
}
