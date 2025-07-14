import '../../../../base/lib/ds_auth_provider.dart';
import 'dart:convert';
import 'dart:io';

/// Manages user sessions for Cognito authentication
class DSSessionManager {
  static const String _sessionDir = '.ds_cognito_sessions';
  static const String _sessionFile = 'cognito_session.json';
  
  /// Stores user session data
  Future<void> storeSession(String userId, String accessToken) async {
    try {
      final sessionData = {
        'userId': userId,
        'accessToken': accessToken,
        'timestamp': DateTime.now().toIso8601String(),
        'provider': 'cognito',
      };
      
      // In a real implementation, this would store to secure storage
      // For now, we'll just store in memory or temporary file
      final directory = Directory(_sessionDir);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      
      final file = File('$_sessionDir/$_sessionFile');
      await file.writeAsString(json.encode(sessionData));
      
      print('Cognito session stored for user: $userId');
    } catch (e) {
      print('Failed to store session: $e');
      throw DSAuthError('Failed to store session');
    }
  }
  
  /// Retrieves user session data
  Future<Map<String, dynamic>?> getSession(String userId) async {
    try {
      final file = File('$_sessionDir/$_sessionFile');
      if (!await file.exists()) {
        return null;
      }
      
      final content = await file.readAsString();
      final sessionData = json.decode(content);
      
      if (sessionData['userId'] == userId) {
        return sessionData;
      }
      
      return null;
    } catch (e) {
      print('Failed to retrieve session: $e');
      return null;
    }
  }
  
  /// Clears user session
  Future<void> clearSession(String userId) async {
    try {
      final file = File('$_sessionDir/$_sessionFile');
      if (await file.exists()) {
        await file.delete();
      }
      
      print('Cognito session cleared for user: $userId');
    } catch (e) {
      print('Failed to clear session: $e');
      throw DSAuthError('Failed to clear session');
    }
  }
  
  /// Checks if session is valid
  Future<bool> isSessionValid(String userId) async {
    try {
      final sessionData = await getSession(userId);
      if (sessionData == null) {
        return false;
      }
      
      final timestamp = DateTime.parse(sessionData['timestamp']);
      final now = DateTime.now();
      
      // Check if session is less than 24 hours old
      final difference = now.difference(timestamp);
      return difference.inHours < 24;
    } catch (e) {
      print('Failed to validate session: $e');
      return false;
    }
  }
  
  /// Updates session timestamp
  Future<void> refreshSession(String userId) async {
    try {
      final sessionData = await getSession(userId);
      if (sessionData != null) {
        sessionData['timestamp'] = DateTime.now().toIso8601String();
        
        final file = File('$_sessionDir/$_sessionFile');
        await file.writeAsString(json.encode(sessionData));
        
        print('Cognito session refreshed for user: $userId');
      }
    } catch (e) {
      print('Failed to refresh session: $e');
      throw DSAuthError('Failed to refresh session');
    }
  }
  
  /// Clears all sessions
  Future<void> clearAllSessions() async {
    try {
      final directory = Directory(_sessionDir);
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
      
      print('All Cognito sessions cleared');
    } catch (e) {
      print('Failed to clear all sessions: $e');
      throw DSAuthError('Failed to clear all sessions');
    }
  }
}
