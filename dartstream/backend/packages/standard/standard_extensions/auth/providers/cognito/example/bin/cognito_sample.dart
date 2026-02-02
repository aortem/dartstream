import 'dart:convert';
import 'dart:io';
import 'package:ds_cognito_auth_provider/ds_cognito_auth_provider.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

// ------------------------------------------------------------------
// Mock Client (Simulates AWS)
// ------------------------------------------------------------------
class MockCognitoHttpClient implements CognitoHttpClient {
  @override
  Future<CognitoHttpResponse> post({
    required String region,
    required String xAmzTarget,
    required Map<String, dynamic> payload,
    Map<String, String>? additionalHeaders,
    Duration? timeout,
  }) async {
    print('\n[MockClient] 📡 Sending Request: $xAmzTarget');
    print('[MockClient] 📦 Payload: $payload');

    // Simulate Network Delay
    await Future.delayed(Duration(milliseconds: 800));

    // Response for SignUp
    if (xAmzTarget.endsWith('SignUp')) {
      return CognitoHttpResponse(
        statusCode: 200,
        headers: {},
        bodyString: jsonEncode({
          'UserConfirmed': true,
          'UserSub': 'mock-user-sub-12345',
        }),
      );
    }

    // Response for AdminInitiateAuth (Sign In)
    if (xAmzTarget.endsWith('AdminInitiateAuth')) {
       return CognitoHttpResponse(
        statusCode: 200,
        headers: {},
        bodyString: jsonEncode({
          'AuthenticationResult': {
            'AccessToken': 'cognito_access_token_mock_123',
            'IdToken': _createMockJwt('mock@user.com'),
            'RefreshToken': 'mock_refresh_token_456',
            'ExpiresIn': 3600,
            'TokenType': 'Bearer',
          }
        }),
      );
    }
    
    return CognitoHttpResponse(statusCode: 200, headers: {}, bodyString: '{}');
  }

  @override
  Future<CognitoHttpResponse> send({
    required String service,
    required String target,
    required String region,
    required Map<String, dynamic> payload,
    required Duration timeout,
    Map<String, String>? headers,
  }) {
    return post(region: region, xAmzTarget: target, payload: payload);
  }

  String _createMockJwt(String email) {
    final header = base64Url.encode(utf8.encode(jsonEncode({'alg': 'HS256', 'typ': 'JWT'})));
    final payload = base64Url.encode(utf8.encode(jsonEncode({
      'sub': '12345-67890',
      'email': email,
      'exp': (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600,
    })));
    return '$header.$payload.mock_sig';
  }
}

// ------------------------------------------------------------------
// Main Application
// ------------------------------------------------------------------
void main(List<String> arguments) async {
  print('==========================================');
  print('   Cognito SDK Verification (Mock Mode)   ');
  print('==========================================');
  print('Running against simulated AWS environment.\n');

  final provider = DSCognitoAuthProvider(
    userPoolId: 'mock_pool_id',
    clientId: 'mock_client_id',
    region: 'us-mock-1',
  );

  // Inject the Mock Client
  await provider.initialize({
      'httpClient': MockCognitoHttpClient()
  });
  
  print('✅ Provider Initialized with MockClient');

  while (true) {
    print('\n------------------------------------------');
    print('1. Simulate Sign Up');
    print('2. Simulate Sign In');
    print('3. Check Current User');
    print('4. Sign Out');
    print('5. Exit');
    stdout.write('Select option: ');
    final choice = stdin.readLineSync()?.trim();

    try {
      switch (choice) {
        case '1':
          print('\n--- Sign Up Flow ---');
          await provider.createAccount('test@example.com', 'password123');
          print('✅ Sign Up Success (Mocked)');
          break;
        case '2':
          print('\n--- Sign In Flow ---');
          await provider.signIn('test@example.com', 'password123');
          print('✅ Sign In Success (Mocked)');
          break;
        case '3':
          final user = await provider.getCurrentUser();
          print('👤 Logged in as: ${user.email} (${user.id})');
          break;
        case '4':
          await provider.signOut();
          print('👋 Signed out');
          break;
        case '5':
          exit(0);
        default:
          print('Invalid option');
      }
    } catch (e) {
      print('❌ Error: $e');
    }
  }
}
