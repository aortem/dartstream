import 'dart:convert';
import 'dart:io';

/// Credential exchange shared by login and server-backed validation.
class CliSession {
  CliSession({Directory? directory, Map<String, String>? environment,
    this.billingOverride, this.platformOverride})
    : environment = environment ?? Platform.environment,
      directory = directory ?? Directory(Platform.environment['DARTSTREAM_CONFIG_DIR'] ??
        '${Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? '.'}/.dartstream');
  final Directory directory;
  final Map<String, String> environment;
  // Constructor injection for local tests; never exposed as a credential CLI flag.
  final Uri? billingOverride, platformOverride;
  String? _token, _tenant, _client, _secret;
  String _environment = 'prod';
  DateTime? _expires;
  File get file => File('${directory.path}/credentials.json');

  Future<Map<String, dynamic>> _request(Uri uri, {Map<String,dynamic>? body, bool authenticated = false}) async {
    if (uri.scheme != 'https' && !(uri.scheme == 'http' && ['127.0.0.1','localhost','::1'].contains(uri.host))) {
      throw StateError('Credential exchange requires HTTPS.');
    }
    final http = HttpClient()..connectionTimeout = const Duration(seconds: 20);
    try {
      final request = await http.openUrl(body == null ? 'GET' : 'POST', uri);
      request.followRedirects = false;
      if (authenticated) {
        request.headers.set('authorization','Bearer $_token');
        request.headers.set('X-Tenant-ID',_tenant!);
      }
      if (body != null) { request.headers.contentType = ContentType.json; request.write(jsonEncode(body)); }
      final response = await request.close().timeout(const Duration(seconds: 20));
      final text = await utf8.decoder.bind(response).join().timeout(const Duration(seconds: 20));
      if (response.statusCode == 401) throw StateError('Invalid, expired or revoked token.');
      if (response.statusCode != 200) throw StateError('DartStream request failed (HTTP ${response.statusCode}).');
      final parsed = jsonDecode(text);
      if (parsed is! Map<String,dynamic>) throw const FormatException('Invalid server response.');
      return parsed;
    } on FormatException {
      throw const FormatException('Invalid server response.');
    } finally { http.close(force: true); }
  }

  Future<void> exchange() async {
    if (_token != null && DateTime.now().isBefore(_expires!)) return;
    _token = null;
    final result = await _request(billingOverride ?? Uri.parse('https://${_environment == 'dev' ? 'dev-' : ''}apibilling.dartstream.io/api/v1/oauth2/token'),
      body: {'grant_type':'client_credentials','client_id':_client,'client_secret':_secret});
    final token = result['access_token']; final seconds = result['expires_in'];
    if (token is! String || seconds is! int || seconds <= 0) throw const FormatException('Invalid token response.');
    Map<String,dynamic> claims;
    try { claims = jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(token.split('.')[1])))) as Map<String,dynamic>; }
    catch (_) { throw const FormatException('Invalid token response.'); }
    if (claims['tenantId'] is! String || (claims['tenantId'] as String).isEmpty || claims['sub'] != _client) {
      throw StateError('Token does not match the credential.');
    }
    _tenant = claims['tenantId']; _token = token;
    _expires = DateTime.now().add(Duration(seconds: seconds > 30 ? seconds - 30 : seconds));
  }

  Future<void> login({String? clientId, String? secret, String env = 'prod'}) async {
    _client = clientId ?? environment['DARTSTREAM_CLIENT_ID'];
    _secret = secret ?? environment['DARTSTREAM_CLIENT_SECRET'] ?? environment['DARTSTREAM_TOKEN'];
    _environment = env; _token = null;
    if (_client == null || _client!.isEmpty || _secret == null || _secret!.isEmpty) {
      throw ArgumentError('Pass --client-id and --token, or DARTSTREAM_CLIENT_ID and DARTSTREAM_CLIENT_SECRET (DARTSTREAM_TOKEN is an alias).');
    }
    await exchange(); // Never create/write credentials after a rejected exchange.
    await directory.create(recursive:true);
    final temp = File('${file.path}.${pid}.${DateTime.now().microsecondsSinceEpoch}.tmp');
    try {
      await temp.create(exclusive: true);
      ProcessResult permissions;
      if (Platform.isWindows) {
        final user = '${Platform.environment['USERDOMAIN']}\\${Platform.environment['USERNAME']}';
        permissions = await Process.run('icacls.exe', [temp.path, '/inheritance:r', '/grant:r', '$user:F']);
      } else { permissions = await Process.run('chmod', ['600',temp.path]); }
      if (permissions.exitCode != 0) throw StateError('Unable to restrict credential file permissions.');
      await temp.writeAsString(jsonEncode({'clientId':_client,'clientSecret':_secret,'environment':_environment}), flush:true);
      await temp.rename(file.path);
    } finally { if (await temp.exists()) await temp.delete(); }
  }

  Future<void> validateProject(String name, {String? env}) async {
    final previous = [_client, _secret, _environment];
    final hasEnv = environment.containsKey('DARTSTREAM_CLIENT_ID') || environment.containsKey('DARTSTREAM_CLIENT_SECRET') || environment.containsKey('DARTSTREAM_TOKEN');
    if (hasEnv) {
      _client=environment['DARTSTREAM_CLIENT_ID']; _secret=environment['DARTSTREAM_CLIENT_SECRET'] ?? environment['DARTSTREAM_TOKEN'];
      _environment=env ?? environment['DARTSTREAM_ENV'] ?? 'prod';
    } else if (_client == null) {
      if (!await file.exists()) throw StateError('Log in first or set the CI credential variables.');
      final saved=jsonDecode(await file.readAsString()) as Map<String,dynamic>;
      _client=saved['clientId']; _secret=saved['clientSecret']; _environment=env ?? saved['environment'] ?? 'prod';
    }
    if (env != null) _environment = env;
    if (previous[0] != _client || previous[1] != _secret || previous[2] != _environment) _token = null;
    if (!['prod','dev'].contains(_environment) || _client == null || _secret == null) throw StateError('Invalid CLI credentials; log in again.');
    await exchange();
    final result=await _request(platformOverride ?? Uri.parse('https://${_environment == 'dev' ? 'dev-' : ''}apiplatform.dartstream.io/api/v1/platform/projects'),authenticated:true);
    final projects=result['projects'];
    if (projects is! List || !projects.any((p) => p is Map && (p['name']==name || p['id']==name || p['slug']==name))) {
      throw StateError('Project was not found in this workspace.');
    }
  }
}
