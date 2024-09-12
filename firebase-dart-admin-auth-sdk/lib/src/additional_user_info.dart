class AdditionalUserInfo {
  final bool isNewUser;
  final String? providerId;
  final Map<String, dynamic>? profile;

  AdditionalUserInfo({
    required this.isNewUser,
    this.providerId,
    this.profile,
  });

  factory AdditionalUserInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalUserInfo(
      isNewUser: json['isNewUser'] ?? false,
      providerId: json['providerId'],
      profile: json['profile'],
    );
  }
}
