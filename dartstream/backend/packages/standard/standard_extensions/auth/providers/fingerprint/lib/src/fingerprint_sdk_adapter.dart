abstract class FingerprintAuthClient {
  Future<Map<String, dynamic>> verify(String payload);
}
