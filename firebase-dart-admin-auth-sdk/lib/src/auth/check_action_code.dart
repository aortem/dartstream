import 'dart:convert';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

///checkaction class
class CheckActionCodeService {
  ///auth
  final FirebaseAuth auth;

  ///checkaction service
  CheckActionCodeService({required this.auth});

  ///checkaction function
  Future<ActionCodeInfo> checkActionCode(String code) async {
    try {
      final url = Uri.https(
        'identitytoolkit.googleapis.com',
        '/v1/accounts:resetPassword',
        {if (auth.apiKey != 'your_api_key') 'key': auth.apiKey},
      );

      final response = await auth.httpClient.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (auth.accessToken != null)
            'Authorization': 'Bearer ${auth.accessToken}',
        },
        body: json.encode({'oobCode': code}),
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

///actioncodeinfo
class ActionCodeInfo {
  ///actioncode
  final String operation;

  ///data
  final Map<String, dynamic> data;

  ///actioncodeinfo
  ActionCodeInfo({required this.operation, required this.data});

  ///fromJSON
  factory ActionCodeInfo.fromJson(Map<String, dynamic> json) {
    return ActionCodeInfo(
      operation: json['requestType'],
      data: {'email': json['email'], 'newEmail': json['newEmail']}
        ..removeWhere((key, value) => value == null),
    );
  }
}
