class IdTokenResult {
  final String token;
  final int expirationTime;
  final int issuedAtTime;
  final String signInProvider;
  final String userId;
  final String authTime;

  IdTokenResult({
    required this.token,
    required this.expirationTime,
    required this.issuedAtTime,
    required this.signInProvider,
    required this.userId,
    required this.authTime,
  });
  @override
  String toString() {
    return 'IdTokenResult{token: $token, expirationTime: $expirationTime, issuedAtTime: $issuedAtTime, signInProvider: $signInProvider, userId: $userId, authTime: $authTime}';
  }

  factory IdTokenResult.fromJson(Map<String, dynamic> json) {
    return IdTokenResult(
      token: json['token'],
      expirationTime: json['expirationTime'],
      issuedAtTime: json['issuedAtTime'],
      signInProvider: json['signInProvider'],
      userId: json['userId'],
      authTime: json['authTime'],
    );
  }
}
