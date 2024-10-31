class ServiceAccount {
  final String? type;
  final String? projectId;
  final String? privateKeyId;
  final String? privateKey;
  final String? clientEmail;
  final String? clientId;
  final String? authUri;
  final String? tokenUri;
  final String? authProviderX509CertUrl;
  final String? clientX509CertUrl;
  final String? universeDomain;

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

  // Copy with method
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

  // Factory method to create ServiceAccount from JSON
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

  // Method to convert ServiceAccount to JSON
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
