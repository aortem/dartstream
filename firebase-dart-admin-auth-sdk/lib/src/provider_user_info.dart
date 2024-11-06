/// Represents information about a user associated with a third-party provider.
class ProviderUserInfo {
  /// The identifier for the authentication provider (e.g., "google.com", "facebook.com").
  String? providerId;

  /// The user's display name from the authentication provider.
  String? displayName;

  /// The URL to the user's profile picture.
  String? photoUrl;

  /// The federated identifier associated with the user, often used for linking users from multiple authentication providers.
  String? federatedId;

  /// The user's email address as provided by the authentication provider.
  String? email;

  /// A raw identifier unique to the provider, used for distinguishing users.
  String? rawId;

  /// The user's screen name or username used in the context of the authentication provider (e.g., Twitter handle).
  String? screenName;

  /// Creates a new instance of [ProviderUserInfo] with optional parameters.
  ///
  /// This constructor allows you to initialize a [ProviderUserInfo] object with various properties such as
  /// [providerId], [displayName], [photoUrl], [federatedId], [email], [rawId], and [screenName]. All parameters are optional.
  ///
  /// Example usage:
  /// ```dart
  /// ProviderUserInfo userInfo = ProviderUserInfo(providerId: "google.com", displayName: "John Doe");
  /// ```
  ProviderUserInfo({
    this.providerId,
    this.displayName,
    this.photoUrl,
    this.federatedId,
    this.email,
    this.rawId,
    this.screenName,
  });

  /// Creates a [ProviderUserInfo] instance from a JSON map.
  ///
  /// This factory constructor takes a [Map<String, dynamic>] (usually from a decoded JSON response) and
  /// returns a [ProviderUserInfo] instance with values populated from the map. This is useful for parsing
  /// JSON data received from an authentication provider.
  ///
  /// Example usage:
  /// ```dart
  /// Map<String, dynamic> jsonData = {
  ///   'providerId': 'google.com',
  ///   'displayName': 'John Doe',
  ///   'photoUrl': 'https://example.com/photo.jpg',
  /// };
  /// ProviderUserInfo userInfo = ProviderUserInfo.fromJson(jsonData);
  /// ```
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

  /// Converts the [ProviderUserInfo] instance to a JSON map.
  ///
  /// This method returns a [Map<String, dynamic>] representing the [ProviderUserInfo] instance,
  /// making it suitable for serializing the data to JSON format, such as when sending it over an API
  /// or storing it in a database.
  ///
  /// Example usage:
  /// ```dart
  /// Map<String, dynamic> jsonData = userInfo.toJson();
  /// ```
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
