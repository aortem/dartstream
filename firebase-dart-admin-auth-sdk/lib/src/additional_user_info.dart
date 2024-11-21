///additional info
class AdditionalUserInfo {
  ///isnewuser
  final bool isNewUser;

  ///providerid
  final String? providerId;

  ///profile
  final Map<String, dynamic>? profile;

  ///additional info
  AdditionalUserInfo({
    required this.isNewUser,
    this.providerId,
    this.profile,
  });

  ///factory
  factory AdditionalUserInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalUserInfo(
      isNewUser: json['isNewUser'] ?? false,
      providerId: json['providerId'],
      profile: json['profile'],
    );
  }
}
