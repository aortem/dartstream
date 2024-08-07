import 'dart:convert';
import 'dart:developer';

import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';

class FirebaseLinkWithCredentailsUser {
  final FirebaseAuth auth;

  FirebaseLinkWithCredentailsUser({required this.auth});
  Future<void> linkWithCredential({
    required String idToken,
    required String accessToken,
    required String providerId,
  }) async {
    try {
      final response = await auth.performRequest('link', {
        'idToken': idToken,
        'accessToken': accessToken,
        'providerId': providerId,
      });
      log("response code $response");

      // Handle response
      if (response.statusCode == 200) {
        log('User successfully Link.');
        return jsonDecode(response.body as String);
      } else {
        log('Error Linking user: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      log('Exception occurred: $e');
    }
  }
}
