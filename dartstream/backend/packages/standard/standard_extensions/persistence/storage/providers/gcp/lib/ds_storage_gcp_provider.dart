import 'dart:convert';
import 'dart:io';

import 'package:_discoveryapis_commons/_discoveryapis_commons.dart' as commons;
import 'package:ds_storage_base/ds_storage_base_export.dart';
import 'package:googleapis/storage/v1.dart' as storage;
import 'package:googleapis_auth/auth_io.dart';

class DSGcpStorageProvider implements DSStorageProvider {
  bool _initialized = false;
  storage.StorageApi? _api;
  AutoRefreshingAuthClient? _client;
  String? _defaultBucket;
  String? _publicBaseUrl;

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    if (_initialized) {
      return;
    }

    final serviceAccount = _loadServiceAccount(config);
    final credentials = ServiceAccountCredentials.fromJson(serviceAccount);

    _defaultBucket = _stringValue(config, 'bucket') ??
        _stringValue(config, 'defaultBucket');
    _publicBaseUrl = _stringValue(config, 'publicUrl') ??
        _stringValue(config, 'baseUrl');

    final scopes = _scopesFromConfig(config) ??
        [storage.StorageApi.devstorageReadWriteScope];

    _client = await clientViaServiceAccount(credentials, scopes);
    _api = storage.StorageApi(_client!);
    _initialized = true;
  }

  @override
  Future<String> uploadFile(
    String path,
    List<int> data, {
    Map<String, dynamic>? metadata,
  }) async {
    final target = _resolveTarget(path);
    final object = storage.Object()
      ..name = target.object
      ..metadata = _stringMap(metadata)
      ..contentType = _contentType(metadata);

    final media = commons.Media(
      Stream<List<int>>.fromIterable([data]),
      data.length,
    );

    final result = await _api!.objects.insert(
      object,
      target.bucket,
      name: target.object,
      uploadMedia: media,
    );

    if (_publicBaseUrl != null && _publicBaseUrl!.trim().isNotEmpty) {
      return _joinUrl(_publicBaseUrl!, target.object);
    }

    return result.mediaLink ?? _defaultObjectUrl(target.bucket, target.object);
  }

  @override
  Future<List<int>> downloadFile(String path) async {
    final target = _resolveTarget(path);
    final response = await _api!.objects.get(
      target.bucket,
      target.object,
      downloadOptions: commons.DownloadOptions.fullMedia,
    );

    final media = response as commons.Media;
    final bytes = <int>[];
    await for (final chunk in media.stream) {
      bytes.addAll(chunk);
    }
    return bytes;
  }

  @override
  Future<void> deleteFile(String path) async {
    final target = _resolveTarget(path);
    await _api!.objects.delete(target.bucket, target.object);
  }

  @override
  Future<List<String>> listFiles(String path, {bool recursive = false}) async {
    final target = _resolveTarget(path, allowEmptyObject: true);
    final results = <String>[];
    String? pageToken;

    do {
      final response = await _api!.objects.list(
        target.bucket,
        prefix: target.object.isEmpty ? null : target.object,
        delimiter: recursive ? null : '/',
        pageToken: pageToken,
      );

      final items = response.items ?? [];
      for (final item in items) {
        if (item.name != null) {
          results.add(item.name!);
        }
      }

      pageToken = response.nextPageToken;
    } while (pageToken != null && pageToken!.isNotEmpty);

    return results;
  }

  @override
  Future<String> getSignedUrl(String path, {Duration? expiry}) async {
    final target = _resolveTarget(path);
    final token = _client?.credentials.accessToken.data;
    if (token == null || token.isEmpty) {
      throw StateError('Access token unavailable for signed URL.');
    }

    final encodedObject = _encodePath(target.object);
    return 'https://storage.googleapis.com/${target.bucket}/$encodedObject?access_token=$token';
  }

  @override
  Future<void> dispose() async {
    _client?.close();
    _client = null;
    _api = null;
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

  Map<String, dynamic> _loadServiceAccount(Map<String, dynamic> config) {
    final raw = config['serviceAccount'] ?? config['credentials'];

    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }

    if (raw is String && raw.trim().isNotEmpty) {
      return _loadJsonFromStringOrFile(raw.trim());
    }

    final path = config['serviceAccountPath'] ?? config['credentialsPath'];
    if (path is String && path.trim().isNotEmpty) {
      return _loadJsonFromFile(path.trim());
    }

    throw ArgumentError('Service account credentials are required.');
  }

  Map<String, dynamic> _loadJsonFromStringOrFile(String value) {
    final file = File(value);
    if (file.existsSync()) {
      return _loadJsonFromFile(value);
    }

    final decoded = jsonDecode(value);
    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }

    throw ArgumentError('Invalid service account JSON.');
  }

  Map<String, dynamic> _loadJsonFromFile(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      throw ArgumentError('Service account file not found: $path');
    }

    final decoded = jsonDecode(file.readAsStringSync());
    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }

    throw ArgumentError('Invalid service account JSON file: $path');
  }

  List<String>? _scopesFromConfig(Map<String, dynamic> config) {
    final raw = config['scopes'];
    if (raw is List) {
      return raw.map((value) => value.toString()).toList();
    }
    return null;
  }

  String? _stringValue(Map<String, dynamic> config, String key) {
    final value = config[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return null;
  }

  String _defaultObjectUrl(String bucket, String object) {
    final encodedObject = _encodePath(object);
    return 'https://storage.googleapis.com/$bucket/$encodedObject';
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

  String? _contentType(Map<String, dynamic>? metadata) {
    if (metadata == null) {
      return null;
    }
    final value = metadata['contentType'] ?? metadata['content_type'];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return null;
  }

  Map<String, String>? _stringMap(Map<String, dynamic>? metadata) {
    if (metadata == null || metadata.isEmpty) {
      return null;
    }
    final result = <String, String>{};
    metadata.forEach((key, value) {
      if (value == null) {
        return;
      }
      result[key] = value.toString();
    });
    return result.isEmpty ? null : result;
  }
}

class _StorageTarget {
  final String bucket;
  final String object;

  _StorageTarget(this.bucket, this.object);
}
