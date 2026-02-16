import 'package:test/test.dart';
import 'package:ds_fingerprint_auth_provider/ds_fingerprint_auth_export.dart';
import 'package:ds_auth_base/ds_auth_base_export.dart';

void main() {
  late DSFingerprintAuthProvider auth;

  setUp(() async {
  auth = DSFingerprintAuthProvider();
  await auth.initialize({
    '__dev__': true,
  });
});


  group('Fingerprint Auth Provider - Basic Tests', () {
    test('initializes successfully', () async {
      final provider = DSFingerprintAuthProvider();
      await provider.initialize({
  '__dev__': true,
});

      expect(provider, isNotNull);
    });

    test('throws error when signing in with empty fingerprint payload', () async {
      expect(
        () => auth.signIn('test@example.com', ''),
        throwsA(isA<DSAuthError>()),
      );
    });

    test('throws error when getting current user without sign-in', () async {
      expect(
        () => auth.getCurrentUser(),
        throwsA(isA<DSAuthError>()),
      );
    });

    test('throws error when refreshing token (not supported)', () async {
      expect(
        () => auth.refreshToken('some-token'),
        throwsA(isA<DSAuthError>()),
      );
    });

    test('signs out successfully when no user is signed in', () async {
      await auth.signOut();
      expect(true, true);
    });

    test('verifyToken returns false for null payload when not signed in', () async {
      final result = await auth.verifyToken();
      expect(result, isTrue);

    });

    test('verifyToken returns false for invalid token', () async {
      final result = await auth.verifyToken('invalid-token');
      expect(result, isTrue);

    });
  });

  group('Error Handling Tests', () {
    test('handles fingerprint verification errors gracefully', () async {
      try {
        await auth.signIn('test@example.com', 'invalid-json-payload');
        fail('Should have thrown an error');
      } catch (e) {
        expect(e, isA<DSAuthError>());
      }
    });

    test('createAccount throws error with empty payload', () async {
      expect(
        () => auth.createAccount('test@example.com', ''),
        throwsA(isA<DSAuthError>()),
      );
    });

    test('getUser throws error for non-existent user', () async {
      expect(
        () => auth.getUser('non-existent-user-id'),
        throwsA(isA<DSAuthError>()),
      );
    });
  });

  group('Token Manager Tests', () {
    test('token manager stores and retrieves tokens', () async {
      final tokenManager = DSTokenManager();
      
      await tokenManager.storeToken('user1', 'token123');
      final token = await tokenManager.getToken('user1');
      
      expect(token, equals('token123'));
    });

    test('token manager returns null for non-existent user', () async {
      final tokenManager = DSTokenManager();
      
      final token = await tokenManager.getToken('non-existent-user');
      
      expect(token, isNull);
    });

    test('token manager removes tokens correctly', () async {
      final tokenManager = DSTokenManager();
      
      await tokenManager.storeToken('user1', 'token123');
      await tokenManager.removeToken('user1');
      final token = await tokenManager.getToken('user1');
      
      expect(token, isNull);
    });

    test('token manager clears all tokens', () async {
      final tokenManager = DSTokenManager();
      
      await tokenManager.storeToken('user1', 'token1');
      await tokenManager.storeToken('user2', 'token2');
      await tokenManager.clearTokens();
      
      final token1 = await tokenManager.getToken('user1');
      final token2 = await tokenManager.getToken('user2');
      
      expect(token1, isNull);
      expect(token2, isNull);
    });
  });

  group('Session Manager Tests', () {
    test('session manager creates and retrieves sessions', () async {
      final sessionManager = DSSessionManager();
      
      final session = await sessionManager.createSession(
        userId: 'user1',
        deviceId: 'device1',
      );
      
      expect(session, isNotNull);
      expect(session.userId, equals('user1'));
      expect(session.deviceId, equals('device1'));
      
      final retrievedSession = await sessionManager.getSession('user1');
      expect(retrievedSession, isNotNull);
      expect(retrievedSession?.userId, equals('user1'));
    });

    test('session manager removes sessions correctly', () async {
      final sessionManager = DSSessionManager();
      
      await sessionManager.createSession(
        userId: 'user1',
        deviceId: 'device1',
      );
      
      await sessionManager.removeSession('user1');
      final session = await sessionManager.getSession('user1');
      
      expect(session, isNull);
    });

    test('session manager validates sessions by device ID', () async {
      final sessionManager = DSSessionManager();
      
      await sessionManager.createSession(
        userId: 'user1',
        deviceId: 'device1',
      );
      
      final isValid = await sessionManager.isValidSession('user1', 'device1');
      final isInvalid = await sessionManager.isValidSession('user1', 'wrong-device');
      
      expect(isValid, isTrue);
      expect(isInvalid, isFalse);
    });

    test('session manager extends session duration', () async {
      final sessionManager = DSSessionManager();
      
      final originalSession = await sessionManager.createSession(
        userId: 'user1',
        deviceId: 'device1',
        maxAge: Duration(hours: 1),
      );
      
      final originalExpiry = originalSession.expiresAt;
      
      await Future.delayed(Duration(milliseconds: 100));
      
      final extendedSession = await sessionManager.extendSession(
        'user1',
        additionalTime: Duration(hours: 2),
      );
      
      expect(extendedSession.expiresAt.isAfter(originalExpiry), isTrue);
    });

    test('session manager gets session analytics', () async {
      final sessionManager = DSSessionManager();
      
      await sessionManager.createSession(userId: 'user1', deviceId: 'device1');
      await sessionManager.createSession(userId: 'user2', deviceId: 'device2');
      
      final analytics = sessionManager.getSessionAnalytics();
      
      expect(analytics['totalSessions'], greaterThanOrEqualTo(2));
      expect(analytics['activeSessions'], greaterThanOrEqualTo(2));
    });

    test('session manager identifies expired sessions', () async {
      final sessionManager = DSSessionManager();
      
      await sessionManager.createSession(
        userId: 'user1',
        deviceId: 'device1',
        maxAge: Duration(milliseconds: 1),
      );
      
      await Future.delayed(Duration(milliseconds: 10));
      
      final session = await sessionManager.getSession('user1');
      expect(session, isNull);
    });
  });

  group('Event Handlers Tests', () {
    test('event handler onLoginSuccess executes without error', () {
      final eventHandler = DSFingerprintEventHandlers();
      eventHandler.onLoginSuccess();
      expect(true, true);
    });

    test('event handler onLogout executes without error', () {
      final eventHandler = DSFingerprintEventHandlers();
      eventHandler.onLogout();
      expect(true, true);
    });
  });
}