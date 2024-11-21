///expection
class FirebaseAuthException implements Exception {
  ///code
  final String code;

  ///message
  final String message;

  ///auth expection

  FirebaseAuthException({required this.code, required this.message});

  @override
  String toString() => 'FirebaseAuthException: $code - $message';
}
