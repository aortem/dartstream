/// Represents a Firebase Service Account for authentication.
class ServiceAccount {
  /// The type of service account (typically "service_account").
  final String? type;

  /// The project ID associated with the service account.
  final String? projectId;

  /// The private key ID associated with the service account.
  final String? privateKeyId;

  /// The private key used for authentication.
  final String? privateKey;

  /// The client email address associated with the service account.
  final String? clientEmail;

  /// The client ID associated with the service account.
  final String? clientId;

  /// The URI for authentication (OAuth 2.0 authorization server).
  final String? authUri;

  /// The URI for token exchange (OAuth 2.0 token endpoint).
  final String? tokenUri;

  /// The URL for the provider's x509 certificate used for verifying token signatures.
  final String? authProviderX509CertUrl;

  /// The URL for the client's x509 certificate used for verifying its identity.
  final String? clientX509CertUrl;

  /// The universe domain for the service account (if applicable).
  final String? universeDomain;

  /// Constructs a new instance of the ServiceAccount class.
  ///
  /// All fields are optional and can be null. Typically, you will provide
  /// the values when using a service account to interact with Firebase or
  /// Google Cloud services.
  ServiceAccount({
    this.type,
    this.projectId,
    this.privateKeyId,
    this.privateKey,
    this.clientEmail,
    this.clientId,
    this.authUri,
    this.tokenUri,
    this.authProviderX509CertUrl,
    this.clientX509CertUrl,
    this.universeDomain,
  });

  /// Creates a new instance of the `ServiceAccount` by copying the current instance
  /// and modifying specific fields. If a field is not provided, the existing
  /// value is kept.
  ///
  /// Example usage:
  /// ```dart
  /// ServiceAccount newAccount = account.copyWith(clientEmail: 'new-email@example.com');
  /// ```
  ServiceAccount copyWith({
    String? type,
    String? projectId,
    String? privateKeyId,
    String? privateKey,
    String? clientEmail,
    String? clientId,
    String? authUri,
    String? tokenUri,
    String? authProviderX509CertUrl,
    String? clientX509CertUrl,
    String? universeDomain,
  }) {
    return ServiceAccount(
      type: type ?? this.type,
      projectId: projectId ?? this.projectId,
      privateKeyId: privateKeyId ?? this.privateKeyId,
      privateKey: privateKey ?? this.privateKey,
      clientEmail: clientEmail ?? this.clientEmail,
      clientId: clientId ?? this.clientId,
      authUri: authUri ?? this.authUri,
      tokenUri: tokenUri ?? this.tokenUri,
      authProviderX509CertUrl:
          authProviderX509CertUrl ?? this.authProviderX509CertUrl,
      clientX509CertUrl: clientX509CertUrl ?? this.clientX509CertUrl,
      universeDomain: universeDomain ?? this.universeDomain,
    );
  }

  /// Creates a new instance of `ServiceAccount` from a JSON map.
  ///
  /// The JSON map should include the fields `type`, `project_id`, `private_key_id`,
  /// `private_key`, `client_email`, `client_id`, `auth_uri`, `token_uri`,
  /// `auth_provider_x509_cert_url`, `client_x509_cert_url`, and `universe_domain`.
  ///
  /// Example usage:
  /// ```dart
  /// Map<String, dynamic> json = {
  ///   'type': 'service_account',
  ///   'project_id': 'your-project-id',
  ///   'client_email': 'your-client-email@example.com',
  /// };
  /// ServiceAccount serviceAccount = ServiceAccount.fromJson(json);
  /// ```
  factory ServiceAccount.fromJson(Map<String, dynamic> json) {
    return ServiceAccount(
      type: json['type'],
      projectId: json['project_id'],
      privateKeyId: json['private_key_id'],
      privateKey: json['private_key'],
      clientEmail: json['client_email'],
      clientId: json['client_id'],
      authUri: json['auth_uri'],
      tokenUri: json['token_uri'],
      authProviderX509CertUrl: json['auth_provider_x509_cert_url'],
      clientX509CertUrl: json['client_x509_cert_url'],
      universeDomain: json['universe_domain'],
    );
  }

  /// Converts the `ServiceAccount` instance to a JSON map.
  ///
  /// This is useful when you need to store or transmit the service account
  /// information in a JSON format.
  ///
  /// Example usage:
  /// ```dart
  /// ServiceAccount serviceAccount = ServiceAccount(...);
  /// Map<String, dynamic> json = serviceAccount.toJson();
  /// ```
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'project_id': projectId,
      'private_key_id': privateKeyId,
      'private_key': privateKey,
      'client_email': clientEmail,
      'client_id': clientId,
      'auth_uri': authUri,
      'token_uri': tokenUri,
      'auth_provider_x509_cert_url': authProviderX509CertUrl,
      'client_x509_cert_url': clientX509CertUrl,
      'universe_domain': universeDomain,
    };
  }
}
