import 'package:test/test.dart';
import 'package:dartstream_backend/packages/standard/standard_extensions/auth/providers/magic/lib/ds_magic_auth_provider.dart';
import 'package:dartstream_backend/packages/standard/standard_extensions/auth/providers/magic/lib/src/ds_token_manager.dart';
import 'package:dartstream_backend/packages/standard/standard_extensions/auth/providers/magic/lib/src/ds_session_manager.dart';
import 'package:dartstream_backend/packages/standard/standard_extensions/auth/providers/magic/lib/src/ds_error_mapper.dart';
import 'package:dartstream_backend/packages/standard/standard_extensions/auth/base/lib/ds_auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  group('DSMagicAuthProvider', () {
    late DSMagicAuthProvider provider;
    const publishableKey = 'test-pub-key';
    const secretKey = 'test-secret-key';
    const testEmail = 'user@example.com';
    const testDIDToken = 'test.did.token';
    const testUserId = 'did:magic:user:123';
    const testUserInfo = {
      'issuer': testUserId,
      'email': testEmail,
      'publicAddress': '0x123',
    };

    setUp(() async {
      provider = DSMagicAuthProvider(
        publishableKey: publishableKey,
        secretKey: secretKey,
      );
      await provider.initialize({});
    });

    test('initialize does not throw', () async {
      expect(() => provider.initialize({}), returnsNormally);
    });

    test('signIn throws if DID token is empty', () async {
      expect(() => provider.signIn(testEmail, ''), throwsA(isA<DSAuthError>()));
    });

    test('signIn stores token and session on success', () async {
      // Mock Magic API response
      final mockClient = MockClient((request) async {
        expect(request.headers['Authorization'], 'Bearer $testDIDToken');
        return http.Response(jsonEncode({'data': testUserInfo}), 200);
      });
      // Inject mock client into provider
      provider = DSMagicAuthProvider(
        publishableKey: publishableKey,
        secretKey: secretKey,
      );
      await provider.initialize({});
      provider._verifyDIDTokenWithMagic = (String didToken) async =>
          testUserInfo;
      await provider.signIn(testEmail, testDIDToken);
      final user = await provider.getCurrentUser();
      expect(user.id, testUserId);
      expect(user.email, testEmail);
    });

    test('signOut clears session and token', () async {
      provider._currentUserId = testUserId;
      provider._currentDIDToken = testDIDToken;
      await provider.signOut();
      expect(provider._currentUserId, isNull);
      expect(provider._currentDIDToken, isNull);
    });

    test('createAccount calls signIn', () async {
      provider._verifyDIDTokenWithMagic = (String didToken) async =>
          testUserInfo;
      await provider.createAccount(testEmail, testDIDToken);
      final user = await provider.getCurrentUser();
      expect(user.id, testUserId);
    });

    test('getCurrentUser throws if not signed in', () async {
      provider._currentUserId = null;
      provider._currentDIDToken = null;
      expect(() => provider.getCurrentUser(), throwsA(isA<DSAuthError>()));
    });

    test('verifyToken returns true for valid token', () async {
      provider._verifyDIDTokenWithMagic = (String didToken) async =>
          testUserInfo;
      provider._currentDIDToken = testDIDToken;
      final result = await provider.verifyToken();
      expect(result, isTrue);
    });

    test('verifyToken returns false for invalid token', () async {
      provider._verifyDIDTokenWithMagic = (String didToken) async => null;
      provider._currentDIDToken = testDIDToken;
      final result = await provider.verifyToken();
      expect(result, isFalse);
    });

    test('refreshToken throws UnimplementedError', () async {
      expect(
        () => provider.refreshToken('dummy'),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('getUser throws UnimplementedError', () async {
      expect(
        () => provider.getUser(testUserId),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('onLoginSuccess and onLogout do not throw', () async {
      final user = DSAuthUser(
        id: testUserId,
        email: testEmail,
        displayName: 'User',
      );
      await provider.onLoginSuccess(user);
      await provider.onLogout();
    });

    // TODO: Add more comprehensive tests for error handling, edge cases, and session/token expiration
  });
}
