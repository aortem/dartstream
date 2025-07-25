import 'package:test/test.dart';
import 'package:dartstream_backend/packages/standard/standard_extensions/auth/providers/magic/lib/ds_magic_auth_provider.dart';
import 'package:dartstream_backend/packages/standard/standard_extensions/auth/providers/magic/lib/src/ds_token_manager.dart';
import 'package:dartstream_backend/packages/standard/standard_extensions/auth/providers/magic/lib/src/ds_session_manager.dart';
import 'package:dartstream_backend/packages/standard/standard_extensions/auth/providers/magic/lib/src/ds_error_mapper.dart';
import 'package:dartstream_backend/packages/standard/standard_extensions/auth/base/lib/ds_auth_provider.dart';
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

    class TestMagicAuthProvider extends DSMagicAuthProvider {
      final Map<String, dynamic>? Function(String)? verifyOverride;

      TestMagicAuthProvider({
        required String publishableKey,
        required String secretKey,
        this.verifyOverride,
      }) : super(publishableKey: publishableKey, secretKey: secretKey);

      @override
      Future<Map<String, dynamic>?> _verifyDIDTokenWithMagic(String didToken) {
        if (verifyOverride != null) {
          return verifyOverride!(didToken);
        }
        return super._verifyDIDTokenWithMagic(didToken);
      }
    }

    setUp(() async {
      provider = TestMagicAuthProvider(
        publishableKey: publishableKey,
        secretKey: secretKey,
        verifyOverride: (_) => Future.value(testUserInfo),
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
      provider._currentDIDToken = testDIDToken;
      final result = await provider.verifyToken();
      expect(result, isTrue);
    });

    test('verifyToken returns false for invalid token', () async {
      final invalidProvider = TestMagicAuthProvider(
        publishableKey: publishableKey,
        secretKey: secretKey,
        verifyOverride: (_) async => null,
      );
      await invalidProvider.initialize({});
      invalidProvider._currentDIDToken = testDIDToken;
      final result = await invalidProvider.verifyToken();
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
  });
}