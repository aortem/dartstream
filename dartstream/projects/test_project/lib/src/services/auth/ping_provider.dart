import 'package:openid_client/openid_client.dart';

/// PingProvider handles authentication with Ping Identity (PingOne/PingFederate)
/// Supports OIDC with PKCE for secure enterprise authentication
class PingProvider {
  // Ping Identity configuration
  // Replace these with your actual Ping Identity environment values
  final String issuerUrl = "https://auth.pingone.com/YOUR_ENV_ID/as";
  final String clientId = "YOUR_CLIENT_ID";
  final List<String> scopes = ["openid", "profile", "email"];

  // Store the authenticated credential
  Credential? _credential;

  // User information cache
  Map<String, dynamic>? _userInfo;

  /// Login with Ping Identity using OIDC + PKCE
  /// Automatically discovers issuer endpoints and initiates authentication flow
  Future<void> login() async {
    try {
      // Discover Ping Identity issuer endpoints
      final issuer = await Issuer.discover(Uri.parse(issuerUrl));

      // Create OIDC client with your client ID
      final client = Client(issuer, clientId);

      // Initialize authenticator with requested scopes
      final authenticator = Authenticator(
        client,
        scopes: scopes,
        // PKCE is enabled by default in openid_client
      );

      // Trigger authentication flow (opens browser/webview)
      _credential = await authenticator.authorize();

      // Fetch user information after successful login
      if (_credential != null) {
        _userInfo = await _credential!.getUserInfo();
      }

      print('✅ Ping Identity login successful');
    } catch (e) {
      print('❌ Ping Identity login failed: $e');
      rethrow;
    }
  }

  /// Check if user is currently authenticated
  bool isLoggedIn() {
    if (_credential == null) return false;

    // Check if access token is still valid
    final accessToken = _credential!.accessToken;
    if (accessToken == null) return false;

    // Check token expiration
    final expiresAt = accessToken.expiresAt;
    if (expiresAt != null && DateTime.now().isAfter(expiresAt)) {
      return false;
    }

    return true;
  }

  /// Logout and revoke tokens
  /// Implements single logout (SLO) with token revocation
  Future<void> logout() async {
    if (_credential != null) {
      try {
        // Revoke access token at Ping Identity
        final accessToken = _credential!.accessToken;
        if (accessToken != null) {
          await _credential!.revokeToken(accessToken);
        }

        // Revoke refresh token if present
        final refreshToken = _credential!.refreshToken;
        if (refreshToken != null) {
          await _credential!.revokeToken(refreshToken);
        }

        print('✅ Ping Identity logout successful');
      } catch (e) {
        print('⚠️  Token revocation failed: $e');
      } finally {
        // Clear local session regardless of revocation result
        _credential = null;
        _userInfo = null;
      }
    }
  }

  /// Get current access token
  String? getAccessToken() {
    return _credential?.accessToken?.value;
  }

  /// Get current ID token
  String? getIdToken() {
    return _credential?.idToken?.rawString;
  }

  /// Get user information from OIDC UserInfo endpoint
  Map<String, dynamic>? getUserInfo() {
    return _userInfo;
  }

  /// Refresh access token using refresh token
  Future<void> refreshToken() async {
    if (_credential == null) {
      throw Exception('No active session to refresh');
    }

    try {
      // openid_client automatically refreshes if refresh token is available
      final newCredential = await _credential!.getTokenResponse();
      _credential = Credential.fromResponse(_credential!.client, newCredential);

      print('✅ Token refreshed successfully');
    } catch (e) {
      print('❌ Token refresh failed: $e');
      rethrow;
    }
  }

  /// Get user email from claims
  String? getUserEmail() {
    return _userInfo?['email'] as String?;
  }

  /// Get user name from claims
  String? getUserName() {
    return _userInfo?['name'] as String?;
  }

  /// Get specific claim from user info
  dynamic getClaim(String claimName) {
    return _userInfo?[claimName];
  }
}
