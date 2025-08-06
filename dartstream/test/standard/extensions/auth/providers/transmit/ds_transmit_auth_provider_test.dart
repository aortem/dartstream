import 'dart:convert';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:transmit_dart_auth_sdk/src/core/transmit_api_client.dart';
// Replace with your real path:
import 'package:your_project_path/standard_extensions/auth/providers/transmit/lib/ds_transmit_auth_provider.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  group('DSTransmitAuthProvider', () {
    late DSTransmitAuthProvider provider;
    late MockApiClient mockApiClient;

    const testEmail = 'user@example.com';
    const testUsername = 'testuser';
    const testPassword = 'testpass';
    const testUserId = 'user123';

    setUp(() async {
      provider = DSTransmitAuthProvider();
      mockApiClient = MockApiClient();

      await provider.initialize({
        'apiKey': 'test-api-key',
        'serviceId': 'test-service-id',
        'region': 'global',
      });

      provider._apiClient = mockApiClient;
      provider._isInitialized = true;
    });

    test('initialize does not throw', () {
      expect(() => provider.initialize({}), returnsNormally);
    });

    test('signIn success updates user and tokens', () async {
      final responseBody = jsonEncode({
        'accessToken': 'fake_access_token',
        'refreshToken': 'fake_refresh_token',
        'userId': testUserId,
      });

      when(
        mockApiClient.post(
          endpoint: anyNamed('endpoint'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response(responseBody, 200));

      await provider.signIn(testUsername, testPassword);

      expect(provider._currentUser, isNotNull);
      expect(provider._currentUser!.id, equals(testUserId));
      expect(provider._tokenManager.getToken(), 'fake_access_token');
      expect(provider._sessionManager.isSessionActive(), isTrue);
    });

    test('signIn throws on error response', () async {
      final errorBody = jsonEncode({'error': 'INVALID_TOKEN'});
      when(
        mockApiClient.post(
          endpoint: anyNamed('endpoint'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response(errorBody, 401));

      expect(
        () async => await provider.signIn(testUsername, 'wrongpass'),
        throwsException,
      );
    });

    test('signOut clears session and token', () async {
      provider._tokenManager.saveToken('fake_access_token');
      provider._sessionManager.createSession('fake_access_token');
      provider._currentUser = DSAuthUser(
        id: testUserId,
        email: testEmail,
        displayName: 'Test User',
      );

      when(
        mockApiClient.post(
          endpoint: anyNamed('endpoint'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('', 200));

      await provider.signOut();

      expect(provider._currentUser, isNull);
      expect(provider._tokenManager.getToken(), isNull);
      expect(provider._sessionManager.isSessionActive(), isFalse);
    });

    test('verifyToken returns true for active token', () async {
      provider._tokenManager.saveToken('fake_access_token');
      final responseBody = jsonEncode({'active': true});

      when(
        mockApiClient.post(
          endpoint: anyNamed('endpoint'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response(responseBody, 200));

      final result = await provider.verifyToken();
      expect(result, isTrue);
    });

    test('verifyToken returns false for inactive token', () async {
      provider._tokenManager.saveToken('fake_access_token');
      final responseBody = jsonEncode({'active': false});

      when(
        mockApiClient.post(
          endpoint: anyNamed('endpoint'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response(responseBody, 200));

      final result = await provider.verifyToken();
      expect(result, isFalse);
    });

    test('refreshToken updates tokens', () async {
      final responseBody = jsonEncode({
        'accessToken': 'new_access_token',
        'refreshToken': 'new_refresh_token',
      });

      when(
        mockApiClient.post(
          endpoint: anyNamed('endpoint'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response(responseBody, 200));

      final newToken = await provider.refreshToken('old_refresh_token');

      expect(newToken, 'new_access_token');
      expect(provider._tokenManager.getToken(), 'new_access_token');
      expect(provider._sessionManager.isSessionActive(), isTrue);
    });

    test('createAccount is unimplemented', () {
      expect(
        () => provider.createAccount('email', 'password'),
        throwsUnimplementedError,
      );
    });

    test('getUser is unimplemented', () {
      expect(() => provider.getUser('userId'), throwsUnimplementedError);
    });

    test('onLoginSuccess and onLogout complete without error', () async {
      final user = DSAuthUser(
        id: testUserId,
        email: testEmail,
        displayName: 'Test User',
      );
      await provider.onLoginSuccess(user);
      await provider.onLogout();
    });
  });
}
