class ProviderUserInfo {
  String? providerId;
  String? displayName;
  String? photoUrl;
  String? federatedId;
  String? email;
  String? rawId;
  String? screenName;

  ProviderUserInfo({
    this.providerId,
    this.displayName,
    this.photoUrl,
    this.federatedId,
    this.email,
    this.rawId,
    this.screenName,
  });

  factory ProviderUserInfo.fromJson(Map<String, dynamic> json) {
    return ProviderUserInfo(
      providerId: json['providerId'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      federatedId: json['federatedId'] as String?,
      email: json['email'] as String?,
      rawId: json['rawId'] as String?,
      screenName: json['screenName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'providerId': providerId,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'federatedId': federatedId,
        'email': email,
        'rawId': rawId,
        'screenName': screenName,
      };
}
