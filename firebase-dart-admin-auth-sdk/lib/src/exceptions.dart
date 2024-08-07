class FirebaseAuthException implements Exception {
  final String? code;
  final String? message;

  FirebaseAuthException({ this.code,  this.message});

  @override
  String toString() => 'FirebaseAuthException: $code - $message';
}
