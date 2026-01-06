import 'package:ds_auth_base/ds_auth_provider.dart';
import 'package:transmit_dart_auth_sdk/transmit_dart_auth_sdk.dart';

import 'src/ds_error_mapper.dart';
import 'src/ds_session_manager.dart';
import 'src/ds_token_manager.dart';
import 'src/ds_event_handlers.dart';

import 'dart:convert';
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:transmit_dart_auth_sdk/src/core/transmit_api_client.dart';
import 'package:transmit_dart_auth_sdk/src/models/tansmit_region.dart';

class DSTransmitAuthProvider implements DSAuthProvider {
  late TransmitAuthConfig _config;
  late ApiClient _apiClient;
  final DSTransmitErrorMapper _errorMapper = DSTransmitErrorMapper();
  final DSTransmitEventHandlers _eventHandlers = DSTransmitEventHandlers();
  final DSTransmitSessionManager _sessionManager = DSTransmitSessionManager();
  final DSTransmitTokenManager _tokenManager = DSTransmitTokenManager();
  DSAuthUser? _currentUser;
  bool _isInitialized = false;

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    final apiKey = config['apiKey'] as String?;
    final serviceId = config['serviceId'] as String?;
    final regionString = config['region'] as String? ?? 'global';

    if (apiKey == null || serviceId == null) {
      throw Exception('Missing required Transmit SDK configuration');
    }

    _config = TransmitAuthConfig(
      apiKey: apiKey,
      serviceId: serviceId,
      region: TransmitRegion.values.firstWhere(
        (e) => e.name == regionString.toLowerCase(),
        orElse: () => TransmitRegion.global,
      ),
    );
    _apiClient = _config.createClient();
    _isInitialized = true;
  }

  @override
  Future<void> signIn(String username, String password) async {
    if (!_isInitialized) throw Exception('Transmit SDK not initialized');

    final response = await _apiClient.post(
      endpoint: '/authenticate/password',
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final accessToken = responseData['accessToken'];
      final refreshToken = responseData['refreshToken'];
      final userId = responseData['userId'];

      if (accessToken == null || refreshToken == null) {
        throw Exception('Missing tokens in authentication response');
      }

      _tokenManager.saveToken(accessToken);
      _sessionManager.createSession(accessToken);

      _currentUser = DSAuthUser(
        id: userId ?? username,
        email: username,
        displayName: username,
        customAttributes: {'provider': 'transmit'},
      );

      _eventHandlers.onLoginSuccess();
      await onLoginSuccess(_currentUser!);
    } else {
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      throw Exception(
        'Sign in failed: ${_errorMapper.mapErrorCode(errorData['error'] ?? 'Unknown error')}',
      );
    }
  }

  @override
  Future<void> signOut() async {
    if (!_isInitialized) throw Exception('Transmit SDK not initialized');
    final token = _tokenManager.getToken();
    if (token == null) return;

    final response = await _apiClient.post(
      endpoint: '/logout',
      body: '', // No body needed for logout
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      _tokenManager.clearToken();
      _sessionManager.endSession();
      _currentUser = null;

      _eventHandlers.onLogout();
      await onLogout();
    } else {
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      throw Exception(
        'Sign out failed: ${_errorMapper.mapErrorCode(errorData['error'] ?? 'Unknown error')}',
      );
    }
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    if (!_isInitialized) throw Exception('Transmit SDK not initialized');

    final response = await _apiClient.post(
      endpoint: '/token/refresh',
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final accessToken = responseData['accessToken'];
      final newRefreshToken = responseData['refreshToken'];

      if (accessToken == null || newRefreshToken == null) {
        throw Exception('Missing tokens in refresh response');
      }

      _tokenManager.saveToken(accessToken);
      _sessionManager.createSession(accessToken);

      return accessToken;
    } else {
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      throw Exception(
        'Token refresh failed: ${_errorMapper.mapErrorCode(errorData['error'] ?? 'Unknown error')}',
      );
    }
  }

  @override
  Future<bool> verifyToken([String? token]) async {
    if (!_isInitialized) throw Exception('Transmit SDK not initialized');
    final activeToken = token ?? _tokenManager.getToken();
    if (activeToken == null) return false;

    final response = await _apiClient.post(
      endpoint: '/token/introspect',
      body: jsonEncode({'token': activeToken}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData['active'] as bool? ?? false;
    }

    return false;
  }

  @override
  Future<void> createAccount(
    String email,
    String password, {
    String? displayName,
  }) {
    throw UnimplementedError(
      'Account creation not supported via Transmit SDK client',
    );
  }

  @override
  Future<DSAuthUser> getCurrentUser() async {
    if (!_isInitialized) throw Exception('Transmit SDK not initialized');
    if (_currentUser == null) throw Exception('No user currently signed in');
    return _currentUser!;
  }

  @override
  Future<DSAuthUser> getUser(String userId) {
    throw UnimplementedError(
      'User lookup not supported via Transmit SDK client',
    );
  }

  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {}

  @override
  Future<void> onLogout() async {}
}
