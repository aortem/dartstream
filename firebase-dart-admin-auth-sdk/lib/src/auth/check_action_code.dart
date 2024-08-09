import 'dart:convert';
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';

class CheckActionCodeService {
  final dynamic auth;

  CheckActionCodeService({required this.auth});

  Future<ActionCodeInfo> checkActionCode(String code) async {
    try {
      final url = Uri.https(
        'identitytoolkit.googleapis.com',
        '/v1/accounts:resetPassword',
        {'key': auth.apiKey},
      );

      final response = await auth.httpClient.post(
        url,
        body: json.encode({
          'oobCode': code,
        }),
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body)['error'];
        throw FirebaseAuthException(
          code: error['message'],
          message: error['message'],
        );
      }

      final data = json.decode(response.body);
      return ActionCodeInfo.fromJson(data);
    } catch (e) {
      throw FirebaseAuthException(
        code: 'check-action-code-error',
        message: 'Failed to check action code: ${e.toString()}',
      );
    }
  }
}

class ActionCodeInfo {
  final String operation;
  final String data;

  ActionCodeInfo({required this.operation, required this.data});

  factory ActionCodeInfo.fromJson(Map<String, dynamic> json) {
    return ActionCodeInfo(
      operation: json['operation'] ?? '',
      data: json['data'] ?? '',
    );
  }
}
