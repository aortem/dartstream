import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/session_result.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;


class AuthApi {
 static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080';
    }

    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080';
    }

    if (Platform.isIOS) {
      return 'http://localhost:8080';
    }

    // macOS / Windows / Linux desktop
    return 'http://localhost:8080';
  }
  
  static Future<SessionResult> signIn(String email, String provider) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/sign-in'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'provider': provider,
        '__e2e__': true,
      }),
    );

    final data = jsonDecode(response.body);

    return SessionResult(
      user: User.fromJson(data['user']),
      sessionId: data['sessionId'],
    );
  }

  static Future<User?> getSession(String sessionId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/session'),
      headers: {'Authorization': sessionId},
    );

    if (response.statusCode != 200) return null;
    return User.fromJson(jsonDecode(response.body)['user']);
  }

  static Future<void> logout(String sessionId) async {
    await http.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: {'Authorization': sessionId},
    );
  }
}
