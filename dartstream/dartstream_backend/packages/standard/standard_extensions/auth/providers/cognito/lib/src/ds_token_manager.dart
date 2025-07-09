import '../../../../base/lib/ds_auth_provider.dart';
import 'dart:convert';

/// Manages JWT tokens for Cognito authentication
class DSTokenManager {
  /// Validates and verifies a JWT token
  Future<bool> verifyToken(String token) async {
    try {
      // Mock implementation for token verification
      // In real implementation, this would:
      // 1. Decode JWT token
      // 2. Verify signature with Cognito public keys
      // 3. Check expiration
      // 4. Validate issuer and audience
      
      if (token.isEmpty) {
        return false;
      }
      
      // Basic JWT format check
      if (!token.contains('.')) {
        return false;
      }
      
      final parts = token.split('.');
      if (parts.length != 3) {
        return false;
      }
      
      // Mock expiration check
      try {
        final payload = _decodeBase64(parts[1]);
        final claims = json.decode(payload);
        
        if (claims['exp'] != null) {
          final expiry = DateTime.fromMillisecondsSinceEpoch(claims['exp'] * 1000);
          if (DateTime.now().isAfter(expiry)) {
            return false;
          }
        }
        
        return true;
      } catch (e) {
        return false;
      }
    } catch (e) {
      print('Token verification error: $e');
      return false;
    }
  }
  
  /// Decodes JWT token payload
  Map<String, dynamic> decodeToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw DSAuthError('Invalid JWT format');
      }
      
      final payload = _decodeBase64(parts[1]);
      return json.decode(payload);
    } catch (e) {
      throw DSAuthError('Failed to decode token: $e');
    }
  }
  
  /// Checks if token is expired
  bool isTokenExpired(String token) {
    try {
      final claims = decodeToken(token);
      if (claims['exp'] != null) {
        final expiry = DateTime.fromMillisecondsSinceEpoch(claims['exp'] * 1000);
        return DateTime.now().isAfter(expiry);
      }
      return false;
    } catch (e) {
      return true;
    }
  }
  
  /// Extracts user ID from token
  String? getUserIdFromToken(String token) {
    try {
      final claims = decodeToken(token);
      return claims['sub'];
    } catch (e) {
      return null;
    }
  }
  
  /// Helper method to decode base64 URL-safe string
  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw DSAuthError('Invalid base64 string');
    }
    
    return utf8.decode(base64Url.decode(output));
  }
}
