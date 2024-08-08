class AdditionalUserInfo {
  final bool isNewUser;
  final String providerId;
  final Map<String, dynamic>? profile;

  AdditionalUserInfo({
    required this.isNewUser,
    required this.providerId,
    this.profile,
  });
}
