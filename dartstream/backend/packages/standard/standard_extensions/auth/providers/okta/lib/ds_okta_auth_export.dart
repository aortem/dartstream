/// DartStream Okta Authentication Provider
/// 
/// This library provides integration with Okta Identity Cloud for authentication
/// and identity management in DartStream applications.
/// 
/// Features:
/// - Universal Directory for user management
/// - Single Sign-On (SSO) capabilities  
/// - Multi-Factor Authentication (MFA)
/// - API Access Management
/// - Adaptive authentication
/// - Lifecycle Management
/// - Custom authorization servers
/// - Social identity providers
/// - Enterprise integration (LDAP, AD, SAML)
/// - Advanced security policies
/// 
/// Usage:
/// ```dart
/// import 'package:ds_okta_auth_provider/ds_okta_auth_export.dart';
/// 
/// final oktaProvider = DSOktaAuthProvider(
///   domain: 'your-okta-domain.okta.com',
///   clientId: 'your-client-id',
///   clientSecret: 'your-client-secret',
///   apiToken: 'your-api-token',
/// );
/// 
/// await oktaProvider.initialize({});
/// DSAuthManager.registerProvider('okta', oktaProvider);
/// ```
library ds_okta_auth_provider;

export 'ds_okta_auth_provider.dart';
