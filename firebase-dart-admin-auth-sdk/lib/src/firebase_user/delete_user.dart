import 'dart:developer';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

import 'dart:convert';


class FirebaseDeleteUser {
  final FirebaseAuth auth;
  FirebaseDeleteUser({required this.auth});
  Future<void> deleteUser(String idToken, String uid) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:delete?key=${auth.apiKey}');
    log("iid is $uid");
    log("idToken is $idToken");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'idToken': idToken,
        'localId': uid,
      }),
    );

    if (response.statusCode == 200) {
      print('Successfully deleted user with UID: $uid');
      FirebaseApp.instance.setCurrentUser(null);
    } else {
      print('Failed to delete user: ${response.body}');
    }
  }
}
