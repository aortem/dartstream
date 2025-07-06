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
  /// Register a provider dynamically with metadata
  static void registerProvider(
      String name, DSAuthProvider provider, [DSAuthProviderMetadata? metadata]) {
    if (_registeredProviders.containsKey(name)) {
      throw ArgumentError('Provider already registered: $name');
    }
    _registeredProviders[name] = provider;
    if (metadata != null) {
      _providerMetadata[name] = metadata;
    }
    log('Registered provider: $name');
  }

  /// Clear all registered providers (useful for testing)
  static void clearProviders() {
    _registeredProviders.clear();
    _providerMetadata.clear();
    log('Cleared all providers');
  }

  /// Unregister a specific provider (useful for testing)
  static void unregisterProvider(String name) {
    _registeredProviders.remove(name);
    _providerMetadata.remove(name);
    log('Unregistered provider: $name');
  }

  DSAuthProviderMetadata? getProviderMetadata(String providerName) {
    return _providerMetadata[providerName];
  }

  late DSAuthProvider _provider;

  /// Initialize with a specific provider
  DSAuthManager(String providerName) {
    if (!_registeredProviders.containsKey(providerName)) {
      throw DSAuthError('Provider not registered: $providerName');
    }
    _provider = _registeredProviders[providerName]!;
    log('Initialized manager with provider: $providerName');
  }

  Future<DSAuthUser> getCurrentUser() {
    log('Fetching current user...');
    return _provider.getCurrentUser();
  }

  Future<void> createAccount(String email, String password,
      {String? displayName}) {
    log('Creating new account...');
    return _provider.createAccount(email, password, displayName: displayName);
  }

  Future<void> signIn(String username, String password) async {
    log('Signing in with provider...');
    await _provider.signIn(username, password);
    // Don't verify token after sign in since Firebase already validated credentials
  }

  Future<void> signOut() {
    log('Signing out with provider...');
    return _provider.signOut();
  }

  Future<DSAuthUser> getUser(String userId) {
    log('Fetching user with ID: $userId');
    return _provider.getUser(userId);
  }

  Future<bool> verifyToken([String? token]) {
    log('Verifying token...');
    return _provider.verifyToken(token);
  }

  Future<String> refreshToken(String refreshToken) {
    log('Refreshing token...');
    return _provider.refreshToken(refreshToken);
  }
}
