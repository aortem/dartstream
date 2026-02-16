import 'ds_middleware_provider.dart';

class DSAuthManager {
  static final Map<String, DSAuthProvider> _registeredProviders = {};

  // Register a provider dynamically
  static void registerProvider(String name, DSAuthProvider provider) {
    _registeredProviders[name] = provider;
  }

  late DSAuthProvider _provider;

  // Initialize with a specific provider
  DSAuthManager(String providerName) {
    if (!_registeredProviders.containsKey(providerName)) {
      throw UnsupportedError('Provider not registered: $providerName');
    }
    _provider = _registeredProviders[providerName]!;
  }

  Future<void> signIn(String username, String password) {
    return _provider.signIn(username, password);
  }

  Future<void> signOut() {
    return _provider.signOut();
  }

  Future<DSMiddlewareUser> getUser(String userId) {
    return _provider.getUser(userId);
  }

  Future<bool> verifyToken(String token) {
    return _provider.verifyToken(token);
  }
}
