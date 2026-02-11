import 'dart:convert';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// A Mock HTTP Client that simulates AWS Cognito responses.
/// This allows the sample app to run without real AWS credentials.
class MockCognitoHttpClient implements CognitoHttpClient {
  @override
  Future<CognitoHttpResponse> post({
    required String region,
    required String xAmzTarget,
    required Map<String, dynamic> payload,
    Map<String, String>? additionalHeaders,
    Duration? timeout,
  }) async {
    print('\n[MockAWS] 📡 Received Request: $xAmzTarget');
    print('[MockAWS] 📦 Payload: $payload');

    // Simulate Network Delay
    await Future.delayed(Duration(milliseconds: 500));

    // 1. Simulate SignUp Response
    if (xAmzTarget.endsWith('SignUp')) {
      print('[MockAWS] ✅ Simulating Successful Sign Up');
      return CognitoHttpResponse(
        statusCode: 200,
        headers: {},
        bodyString: jsonEncode({
          'UserConfirmed': true,
          'UserSub': 'mock-user-sub-12345',
        }),
      );
    }

    // 2. Simulate SignIn (AdminInitiateAuth) Response
    if (xAmzTarget.endsWith('AdminInitiateAuth')) {
      print('[MockAWS] ✅ Simulating Successful Sign In');
      return CognitoHttpResponse(
        statusCode: 200,
        headers: {},
        bodyString: jsonEncode({
          'AuthenticationResult': {
            'AccessToken': 'cognito_access_token_mock_123',
            'IdToken': _createMockJwt('test@example.com'),
            'RefreshToken': 'mock_refresh_token_456',
            'ExpiresIn': 3600,
            'TokenType': 'Bearer',
          },
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

  // Helper to create a fake valid-looking JWT
  String _createMockJwt(String email) {
    final header = base64Url.encode(
      utf8.encode(jsonEncode({'alg': 'HS256', 'typ': 'JWT'})),
    );
    final payload = base64Url.encode(
      utf8.encode(
        jsonEncode({
          'sub': '12345-67890',
          'email': email,
          'exp': (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600,
        }),
      ),
    );
    return '$header.$payload.mock_sig';
  }
}
