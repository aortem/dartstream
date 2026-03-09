import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:ds_storage_base/ds_storage_base_export.dart';
import 'package:http/http.dart' as http;

class DSAzureBlobStorageProvider implements DSStorageProvider {
  static const String _apiVersion = '2023-11-03';

  bool _initialized = false;
  late String _accountName;
  late List<int> _accountKeyBytes;
  String? _defaultContainer;
  late bool _useHttps;
  late String _endpointSuffix;
  String? _publicBaseUrl;
  http.Client _httpClient = http.Client();

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    if (_initialized) {
      return;
    }

    _accountName = _requireString(config, ['accountName', 'account_name']);
    final accountKey = _requireString(config, ['accountKey', 'account_key']);
    _accountKeyBytes = base64.decode(accountKey);
    _defaultContainer =
        _stringValue(config, 'container') ??
        _stringValue(config, 'defaultContainer');
    _useHttps =
        _boolValue(config, 'useHttps') ??
        _boolValue(config, 'https') ??
        _boolValue(config, 'ssl') ??
        true;
    _endpointSuffix =
        _stringValue(config, 'endpointSuffix') ?? 'core.windows.net';
    _publicBaseUrl =
        _stringValue(config, 'publicUrl') ?? _stringValue(config, 'baseUrl');

    _initialized = true;
  }

  @override
  Future<String> uploadFile(
    String path,
    List<int> data, {
    Map<String, dynamic>? metadata,
  }) async {
    final target = _resolveTarget(path);
    final uri = _blobUri(target.container, target.blob);
    final date = _rfc1123Now();
    final contentType = _contentType(metadata) ?? 'application/octet-stream';

    final headers = <String, String>{
      'Content-Type': contentType,
      'Content-Length': data.length.toString(),
      'x-ms-blob-type': 'BlockBlob',
      'x-ms-date': date,
      'x-ms-version': _apiVersion,
    };
    _appendMetadataHeaders(headers, metadata);
    headers['Authorization'] = _sharedKeyAuthorization(
      method: 'PUT',
      uri: uri,
      headers: headers,
    );

    final response = await _httpClient.put(uri, headers: headers, body: data);
    _expectSuccess(response, {201}, 'upload blob');

    if (_publicBaseUrl != null && _publicBaseUrl!.trim().isNotEmpty) {
      return _joinUrl(_publicBaseUrl!, target.blob);
    }

    return uri.toString();
  }

  @override
  Future<List<int>> downloadFile(String path) async {
    final target = _resolveTarget(path);
    final uri = _blobUri(target.container, target.blob);
    final date = _rfc1123Now();

    final headers = <String, String>{
      'x-ms-date': date,
      'x-ms-version': _apiVersion,
    };
    headers['Authorization'] = _sharedKeyAuthorization(
      method: 'GET',
      uri: uri,
      headers: headers,
    );

    final response = await _httpClient.get(uri, headers: headers);
    _expectSuccess(response, {200}, 'download blob');
    return response.bodyBytes;
  }

  @override
  Future<void> deleteFile(String path) async {
    final target = _resolveTarget(path);
    final uri = _blobUri(target.container, target.blob);
    final date = _rfc1123Now();

    final headers = <String, String>{
      'x-ms-date': date,
      'x-ms-version': _apiVersion,
    };
    headers['Authorization'] = _sharedKeyAuthorization(
      method: 'DELETE',
      uri: uri,
      headers: headers,
    );

    final response = await _httpClient.delete(uri, headers: headers);
    _expectSuccess(response, {202, 404}, 'delete blob');
  }

  @override
  Future<List<String>> listFiles(String path, {bool recursive = false}) async {
    final target = _resolveTarget(path, allowEmptyBlob: true);
    final results = <String>[];
    String? marker;

    do {
      final params = <String, String>{
        'restype': 'container',
        'comp': 'list',
        if (target.blob.isNotEmpty) 'prefix': target.blob,
        if (!recursive) 'delimiter': '/',
        if (marker != null && marker.isNotEmpty) 'marker': marker,
      };

      final uri = _containerUri(target.container, params);
      final date = _rfc1123Now();
      final headers = <String, String>{
        'x-ms-date': date,
        'x-ms-version': _apiVersion,
      };
      headers['Authorization'] = _sharedKeyAuthorization(
        method: 'GET',
        uri: uri,
        headers: headers,
      );

      final response = await _httpClient.get(uri, headers: headers);
      _expectSuccess(response, {200}, 'list blobs');

      results.addAll(_parseBlobNames(response.body));
      marker = _parseXmlTag(response.body, 'NextMarker');
    } while (marker != null && marker.isNotEmpty);

    return results;
  }

  @override
  Future<String> getSignedUrl(String path, {Duration? expiry}) async {
    final target = _resolveTarget(path);
    final expiresOn = DateTime.now().toUtc().add(
      expiry ?? const Duration(hours: 1),
    );
    final startsOn = DateTime.now().toUtc().subtract(
      const Duration(minutes: 5),
    );
    final version = _apiVersion;
    final resource = 'b';
    final permissions = 'r';
    final protocol = _useHttps ? 'https' : 'https,http';

    final canonicalizedResource =
        '/blob/$_accountName/${target.container}/${target.blob}';
    final st = _toIso8601WithoutMillis(startsOn);
    final se = _toIso8601WithoutMillis(expiresOn);

    final stringToSign = [
      permissions,
      st,
      se,
      canonicalizedResource,
      '',
      '',
      protocol,
      version,
      resource,
      '',
      '',
      '',
      '',
      '',
      '',
      '',
    ].join('\n');

    final signature = _computeHmacBase64(stringToSign);
    final params = <String, String>{
      'sv': version,
      'spr': protocol,
      'st': st,
      'se': se,
      'sr': resource,
      'sp': permissions,
      'sig': signature,
    };

    final uri = _blobUri(target.container, target.blob, params);
    return uri.toString();
  }

  @override
  Future<void> dispose() async {
    _httpClient.close();
    _httpClient = http.Client();
    _initialized = false;
  }

  _StorageTarget _resolveTarget(String path, {bool allowEmptyBlob = false}) {
    final trimmed = path.trim().replaceAll(RegExp(r'^/+'), '');
    if (_defaultContainer != null && _defaultContainer!.isNotEmpty) {
      if (!allowEmptyBlob && trimmed.isEmpty) {
        throw ArgumentError('Blob path is required.');
      }
      return _StorageTarget(_defaultContainer!, trimmed);
    }

    final segments = trimmed.split('/');
    if (segments.length < 2) {
      throw ArgumentError(
        'Path must include container and blob (container/blob).',
      );
    }

    final container = segments.first;
    final blob = segments.skip(1).join('/');
    if (!allowEmptyBlob && blob.isEmpty) {
      throw ArgumentError('Blob path is required.');
    }

    return _StorageTarget(container, blob);
  }

  Uri _blobUri(
    String container,
    String blob, [
    Map<String, String>? queryParameters,
  ]) {
    final scheme = _useHttps ? 'https' : 'http';
    final encodedBlob = blob
        .split('/')
        .where((segment) => segment.isNotEmpty)
        .map(Uri.encodeComponent)
        .join('/');

    return Uri(
      scheme: scheme,
      host: '$_accountName.blob.$_endpointSuffix',
      path: '/$container/$encodedBlob',
      queryParameters: queryParameters == null || queryParameters.isEmpty
          ? null
          : queryParameters,
    );
  }

  Uri _containerUri(String container, Map<String, String> queryParameters) {
    final scheme = _useHttps ? 'https' : 'http';
    return Uri(
      scheme: scheme,
      host: '$_accountName.blob.$_endpointSuffix',
      path: '/$container',
      queryParameters: queryParameters,
    );
  }

  String _sharedKeyAuthorization({
    required String method,
    required Uri uri,
    required Map<String, String> headers,
  }) {
    final canonicalizedHeaders =
        headers.entries
            .where((entry) => entry.key.toLowerCase().startsWith('x-ms-'))
            .map(
              (entry) => MapEntry(entry.key.toLowerCase(), entry.value.trim()),
            )
            .toList()
          ..sort((a, b) => a.key.compareTo(b.key));

    final canonicalizedHeadersString = canonicalizedHeaders
        .map((entry) => '${entry.key}:${entry.value}\n')
        .join();

    final canonicalizedResource = _canonicalizedResource(uri);

    final contentLength =
        headers['Content-Length'] ?? headers['content-length'];
    final normalizedContentLength =
        (contentLength == null || contentLength == '0') ? '' : contentLength;

    final stringToSign = [
      method.toUpperCase(),
      '',
      '',
      normalizedContentLength,
      '',
      headers['Content-Type'] ?? headers['content-type'] ?? '',
      '',
      '',
      '',
      '',
      '',
      '',
      canonicalizedHeadersString + canonicalizedResource,
    ].join('\n');

    final signature = _computeHmacBase64(stringToSign);
    return 'SharedKey $_accountName:$signature';
  }

  String _canonicalizedResource(Uri uri) {
    final buffer = StringBuffer('/$_accountName${uri.path}');

    final sortedQuery = uri.queryParametersAll.entries.toList()
      ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));
    for (final entry in sortedQuery) {
      final values = [...entry.value]..sort();
      buffer.write('\n${entry.key.toLowerCase()}:${values.join(',')}');
    }
    return buffer.toString();
  }

  void _appendMetadataHeaders(
    Map<String, String> headers,
    Map<String, dynamic>? metadata,
  ) {
    if (metadata == null || metadata.isEmpty) {
      return;
    }

    metadata.forEach((key, value) {
      if (value == null) {
        return;
      }
      if (key == 'contentType' || key == 'content_type') {
        return;
      }
      headers['x-ms-meta-$key'] = value.toString();
    });
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

  List<String> _parseBlobNames(String xml) {
    final matches = RegExp(
      r'<Blob>\s*<Name>([^<]+)</Name>',
      dotAll: true,
    ).allMatches(xml);
    return matches.map((match) => _xmlDecode(match.group(1)!)).toList();
  }

  String? _parseXmlTag(String xml, String tag) {
    final match = RegExp('<$tag>([^<]*)</$tag>').firstMatch(xml);
    if (match == null) {
      return null;
    }
    final raw = match.group(1);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return _xmlDecode(raw);
  }

  String _xmlDecode(String value) {
    return value
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'");
  }

  String _rfc1123Now() {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final now = DateTime.now().toUtc();
    final w = weekdays[now.weekday - 1];
    final m = months[now.month - 1];
    final day = now.day.toString().padLeft(2, '0');
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');
    return '$w, $day $m ${now.year} $hour:$minute:$second GMT';
  }

  String _toIso8601WithoutMillis(DateTime time) {
    final utc = time.toUtc();
    final month = utc.month.toString().padLeft(2, '0');
    final day = utc.day.toString().padLeft(2, '0');
    final hour = utc.hour.toString().padLeft(2, '0');
    final minute = utc.minute.toString().padLeft(2, '0');
    final second = utc.second.toString().padLeft(2, '0');
    return '${utc.year}-$month-${day}T$hour:$minute:${second}Z';
  }

  String _computeHmacBase64(String value) {
    final digest = Hmac(sha256, _accountKeyBytes).convert(utf8.encode(value));
    return base64.encode(digest.bytes);
  }

  String _joinUrl(String baseUrl, String path) {
    final trimmedBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final trimmedPath = path.startsWith('/') ? path.substring(1) : path;
    return '$trimmedBase/$trimmedPath';
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

  void _expectSuccess(http.Response response, Set<int> okCodes, String action) {
    if (okCodes.contains(response.statusCode)) {
      return;
    }
    throw StateError(
      'Failed to $action. HTTP ${response.statusCode}: ${response.body}',
    );
  }
}

class _StorageTarget {
  final String container;
  final String blob;

  _StorageTarget(this.container, this.blob);
}
