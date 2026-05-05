import 'ds_ai_models.dart';
import 'ds_ai_provider.dart';

/// Central registry and dispatch layer for DartStream AI providers.
class DSAIManager {
  static final Map<String, DSAIProvider> _providers = {};
  static final Map<String, DSAIProviderMetadata> _metadata = {};

  /// Registers an AI provider by name.
  static void registerProvider(
    String name,
    DSAIProvider provider,
    DSAIProviderMetadata metadata,
  ) {
    if (_providers.containsKey(name)) {
      throw DSAIError(
        'Provider already registered: $name',
        code: 'provider_already_registered',
      );
    }
    _providers[name] = provider;
    _metadata[name] = metadata;
  }

  /// Returns registered provider names.
  static List<String> getRegisteredProviderNames() => _providers.keys.toList();

  /// Returns metadata for a registered provider.
  static DSAIProviderMetadata? getProviderMetadata(String providerName) {
    return _metadata[providerName];
  }

  /// Initializes a provider.
  static Future<void> initializeProvider(
    String providerName,
    Map<String, Object?> config,
  ) {
    return _getProvider(providerName).initialize(config);
  }

  /// Generates text with the selected provider.
  static Future<DSAIResponse> generateText(
    String providerName,
    DSAIRequest request,
  ) {
    return _getProvider(providerName).generateText(request);
  }

  /// Runs a named workflow with the selected provider.
  static Future<DSAIWorkflowResult> runWorkflow(
    String providerName,
    DSAIWorkflowRequest request,
  ) {
    return _getProvider(providerName).runWorkflow(request);
  }

  /// Releases provider resources.
  static Future<void> disposeProvider(String providerName) {
    return _getProvider(providerName).dispose();
  }

  static DSAIProvider _getProvider(String providerName) {
    final provider = _providers[providerName];
    if (provider == null) {
      throw DSAIError(
        'Provider not registered: $providerName',
        code: 'provider_not_registered',
      );
    }
    return provider;
  }
}
