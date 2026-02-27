import 'package:test/test.dart';
import 'package:dartstream_backend/packages/standard/standard_extensions/auth/providers/magic/lib/ds_magic_auth_provider.dart';
import 'package:dartstream_backend/packages/standard/standard_extensions/auth/base/lib/ds_auth_provider.dart';

class TestMagicAuthProvider extends DSMagicAuthProvider {
  final Future<Map<String, dynamic>?> Function(String)? verifyOverride;

  TestMagicAuthProvider({
    required String publishableKey,
    required String secretKey,
    this.verifyOverride,
  }) : super.internal(publishableKey: publishableKey, secretKey: secretKey);

  @override
  Future<Map<String, dynamic>?> verifyDIDTokenWithMagic(String didToken) {
    if (verifyOverride != null) {
      return verifyOverride!(didToken);
    }
    return super.verifyDIDTokenWithMagic(didToken);
  }
}

void main() {
  group('DSMagicAuthProvider', () {
    late TestMagicAuthProvider provider;
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

<<<<<<< HEAD
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
=======
    setUp(() async {
      provider = TestMagicAuthProvider(
        publishableKey: publishableKey,
        secretKey: secretKey,
        verifyOverride: (_) async => testUserInfo,
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
      expect(provider.isSignedIn, isTrue);
    });

    test('signOut clears session and token', () async {
      await provider.signIn(testEmail, testDIDToken);
      await provider.signOut();
      expect(provider.currentUserId, isNull);
      expect(provider.currentDIDToken, isNull);
      expect(provider.isSignedIn, isFalse);
    });

    test('createAccount calls signIn', () async {
      await provider.createAccount(testEmail, testDIDToken);
      final user = await provider.getCurrentUser();
      expect(user.id, testUserId);
      expect(provider.isSignedIn, isTrue);
    });

    test('getCurrentUser throws if not signed in', () async {
      provider.clearCurrentSession();
      expect(() => provider.getCurrentUser(), throwsA(isA<DSAuthError>()));
    });

    test('verifyToken returns true for valid token', () async {
      await provider.signIn(testEmail, testDIDToken);
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
      final result = await invalidProvider.verifyToken('bad.token');
      expect(result, isFalse);
    });

    test('refreshToken returns token when valid', () async {
      await provider.signIn(testEmail, testDIDToken);
      final refreshed = await provider.refreshToken(testDIDToken);
      expect(refreshed, equals(testDIDToken));
    });

    test('refreshToken throws on invalid token', () async {
      expect(
        () => provider.refreshToken('invalid'),
        throwsA(isA<DSAuthError>()),
      );
    });

    test('getUser returns current user for matching id', () async {
      await provider.signIn(testEmail, testDIDToken);
      final user = await provider.getUser(testUserId);
      expect(user.id, testUserId);
    });

    test('getUser throws for unknown id', () async {
      await provider.signIn(testEmail, testDIDToken);
      expect(
        () => provider.getUser('unknown'),
        throwsA(isA<DSAuthError>()),
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
>>>>>>> main
