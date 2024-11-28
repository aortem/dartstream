import 'ds_auth_provider.dart';

//Add MetaData For the Providers
class DSAuthProviderMetadata {
  final String type;
  final String region;
  final String clientId;

  DSAuthProviderMetadata({
    required this.type,
    required this.region,
    required this.clientId,
  });
}

class DSAuthManager {
  static final Map<String, DSAuthProvider> _registeredProviders = {};
  static final Map<String, DSAuthProviderMetadata> _providerMetadata = {};
  static bool enableDebugging = false;

  static void log(String message) {
    if (enableDebugging) {
      print('DSAuthManager: $message');
    }
  }

  // Register a provider dynamically
  static void registerProvider(
      String name, DSAuthProvider provider, DSAuthProviderMetadata metadata) {
    _registeredProviders[name] = provider;
    _providerMetadata[name] = metadata;
    log('Registered provider: $name');
  }

  DSAuthProviderMetadata? getProviderMetadata(String providerName) {
    return _providerMetadata[providerName];
  }

  late DSAuthProvider _provider;

  // Initialize with a specific provider
  DSAuthManager(String providerName) {
    if (!_registeredProviders.containsKey(providerName)) {
      throw DSAuthError('Provider not registered: $providerName');
    }
    _provider = _registeredProviders[providerName]!;
    log('Initialized manager with provider: $providerName');
  }

  Future<void> signIn(String username, String password) {
    log('Signing in with provider...');
    return _provider.signIn(username, password);
  }

  Future<void> signOut() {
    log('Signing out with provider...');
    return _provider.signOut();
  }

  Future<DSAuthUser> getUser(String userId) {
    log('Fetching user with ID: $userId');
    return _provider.getUser(userId);
  }

  Future<bool> verifyToken(String token) {
    log('Verifying token...');
    return _provider.verifyToken(token);
  }

  Future<String> refreshToken(String refreshToken) {
    log('Refreshing token...');
    return _provider.refreshToken(refreshToken);
  }
}
