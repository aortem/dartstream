import 'package:fingerprint_dart_auth_sdk/fingerprint_dart_auth_sdk.dart';
import 'fingerprint_sdk_adapter.dart';

class FingerprintAuthSdk implements FingerprintAuthClient {
  final FingerprintAuth _sdk;

  FingerprintAuthSdk({required String apiKey})
      : _sdk = FingerprintAuth(apiKey: apiKey);

  @override
  Future<Map<String, dynamic>> verify(String payload) async {
    final result = await _sdk.verify(payload);
    return Map<String, dynamic>.from(result);
  }
}
