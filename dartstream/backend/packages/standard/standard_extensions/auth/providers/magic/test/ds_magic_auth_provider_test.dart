import 'dart:convert';
import 'package:test/test.dart';
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ds_magic_auth_provider/ds_magic_auth_provider.dart';

// Subclass to override verification logic for testing
class TestDSMagicAuthProvider extends DSMagicAuthProvider {
  TestDSMagicAuthProvider({
    required String publishableKey,
    required String secretKey,
  }) : super.internal(publishableKey: publishableKey, secretKey: secretKey);

  @override
  Future<Map<String, dynamic>?> verifyDIDTokenWithMagic(String didToken) async {
    // Basic structural validation for test tokens
    final parts = didToken.split('.');
    if (parts.length != 3) return null;
    
    // Simulate invalid signature/token if part 3 is "invalid_signature"
    if (parts[2] == 'invalid_signature') return null;

    return {
      'issuer': 'did:ethr:0x1234567890',
      'email': 'test@example.com',
      'publicAddress': '0x1234567890',
    };
  }
}

void main() {
  // Helper to create a token with valid-ish payload for decoding
  String createTestToken({int? exp}) {
    final header = base64Url.encode(utf8.encode('{"typ":"JWT","alg":"none"}'));
    final Map<String, dynamic> payloadMap = {
      'iss': 'did:ethr:0x1234567890',
      'email': 'test@example.com',
      'publicAddress': '0x1234567890',
    };
    if (exp != null) {
      payloadMap['exp'] = exp;
    } else {
      // Default expiry in future
      payloadMap['exp'] = (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600;
    }
    
    final payload = base64Url.encode(utf8.encode(json.encode(payloadMap))).replaceAll('=', '');
    return '$header.$payload.signature';
  }

  group('DSMagicAuthProvider Tests', () {
    late TestDSMagicAuthProvider provider;
    late String validToken;

    setUp(() {
      // Reset the singleton instance before each test
      DSMagicAuthProvider.resetInstance();
      
      provider = TestDSMagicAuthProvider(
        publishableKey: 'pk_test_123',
        secretKey: 'sk_test_123',
      );
      validToken = createTestToken();
    });

    test('initialize sets up internal managers', () async {
      await provider.initialize({});
    });

    test('signIn authenticates user and sets session', () async {
      await provider.initialize({});
      await provider.signIn('test@example.com', validToken);

      expect(await provider.verifyToken(), isTrue);
      final user = await provider.getCurrentUser();
      expect(user.email, equals('test@example.com'));
      expect(user.displayName, equals('0x1234567890'));
      
      // Verify getUser works for current user
      final userById = await provider.getUser(user.id);
      expect(userById.id, equals(user.id));
    });

    test('signIn fails with invalid token', () async {
      await provider.initialize({});
      final invalidToken = 'header.payload.invalid_signature'; // Test provider logic rejects this
      
      expect(
        () => provider.signIn('test@example.com', invalidToken),
        throwsA(isA<DSAuthError>()),
      );
    });

    test('createAccount delegates to signIn', () async {
      await provider.initialize({});
      await provider.createAccount('test@example.com', validToken);
      
      expect(await provider.verifyToken(), isTrue);
      final user = await provider.getCurrentUser();
      expect(user.email, equals('test@example.com'));
    });

    test('getUser throws if user mismatch', () async {
      await provider.initialize({});
      await provider.signIn('test@example.com', validToken);
      
      expect(
        () => provider.getUser('other_user_id'),
        throwsA(isA<DSAuthError>()),
      );
    });

    test('refreshToken returns token if valid', () async {
      await provider.initialize({});
      // Note: refreshToken doesn't strictly need sign-in, it validates the token passed
      final refreshed = await provider.refreshToken(validToken);
      expect(refreshed, equals(validToken));
    });

    test('refreshToken throws if token invalid', () async {
      await provider.initialize({});
      expect(
        () => provider.refreshToken('header.payload.invalid_signature'),
        throwsA(isA<DSAuthError>()),
      );
    });

    test('signOut clears session', () async {
      await provider.initialize({});
      await provider.signIn('test@example.com', validToken);
      
      await provider.signOut();
      
      expect(await provider.verifyToken(), isFalse);
      expect(
        () => provider.getCurrentUser(),
        throwsA(isA<DSAuthError>()),
      );
    });
  });
}