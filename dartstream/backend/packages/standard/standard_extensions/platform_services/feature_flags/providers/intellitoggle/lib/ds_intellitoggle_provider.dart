import 'package:ds_feature_flags_base/ds_feature_flag_provider.dart';
import 'package:openfeature_dart_server_sdk/hooks.dart';
import 'package:openfeature_provider_intellitoggle/openfeature_provider_intellitoggle.dart';

import 'src/ds_intellitoggle_config.dart';
import 'src/ds_intellitoggle_error_mapper.dart';
import 'src/ds_intellitoggle_event_handler.dart';

/// DSIntelliToggleProvider integrates IntelliToggle with DartStream's
/// feature flag system using the OpenFeature standard.
///
/// This provider wraps the official IntelliToggle OpenFeature SDK and
/// implements DartStream's [DSFeatureFlagProvider] interface.
///
/// Example usage:
/// ```dart
/// final provider = DSIntelliToggleProvider(
///   clientId: Platform.environment['INTELLITOGGLE_CLIENT_ID']!,
///   clientSecret: Platform.environment['INTELLITOGGLE_CLIENT_SECRET']!,
///   tenantId: Platform.environment['INTELLITOGGLE_TENANT_ID']!,
/// );
/// await provider.initialize();
/// ```
class DSIntelliToggleProvider implements DSFeatureFlagProvider {
  bool _isInitialized = false;

  final String clientId;
  final String clientSecret;
  final String tenantId;
  final DSIntelliToggleConfig config;

  late final IntelliToggleProvider _intelliToggleProvider;
  late final IntelliToggleClient _client;
  late final DSIntelliToggleEventHandler _eventHandler;

  /// Constructor to initialize the DSIntelliToggleProvider.
  DSIntelliToggleProvider({
    required this.clientId,
    required this.clientSecret,
    required this.tenantId,
    DSIntelliToggleConfig? config,
  }) : config = config ?? DSIntelliToggleConfig();

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw DSIntelliToggleException(
        code: 'not_initialized',
        message: 'DSIntelliToggleProvider is not initialized. Call initialize() first.',
      );
    }
  }

  /// Initializes the IntelliToggle provider.
  /// Must be called before evaluating any flags.
  Future<void> initialize() async {
    if (_isInitialized) {
      print('⚠️  Provider already initialized, skipping re-initialization');
      return;
    }

    try {
      _intelliToggleProvider = IntelliToggleProvider(
        clientId: clientId,
        clientSecret: clientSecret,
        tenantId: tenantId,
        options: config.toIntelliToggleOptions(),
      );

      await _intelliToggleProvider.initialize();

      final api = OpenFeatureAPI();
      api.setProvider(_intelliToggleProvider);

      final clientMetadata = ClientMetadata(
        name: 'dartstream-client',
        version: '0.0.1',
      );
      final hookManager = HookManager();
      final defaultEvalContext = EvaluationContext(attributes: {});
      final featureClient = FeatureClient(
        metadata: clientMetadata,
        provider: _intelliToggleProvider,
        hookManager: hookManager,
        defaultContext: defaultEvalContext,
      );

      _client = IntelliToggleClient(featureClient);
      _eventHandler = DSIntelliToggleEventHandler(
        provider: _intelliToggleProvider,
      );
      _eventHandler.initialize();

      _isInitialized = true;
    } catch (e) {
      throw DSIntelliToggleErrorMapper.mapError(e);
    }
  }

  /// Shuts down the IntelliToggle provider and cleans up resources.
  /// Shuts down the IntelliToggle provider and cleans up resources.
  Future<void> shutdown() async {
    if (_isInitialized) {
      await _intelliToggleProvider.shutdown();
      _isInitialized = false;
    }
  }

  /// Fetches the value of a feature flag as a boolean.
  ///
  /// [flagKey]: The unique identifier for the flag.
  /// [defaultValue]: Value returned if flag cannot be evaluated.
  /// [context]: Optional evaluation context for targeting.
  @override
  Future<bool> getBooleanFlag(
    String flagKey, {
    bool defaultValue = false,
    Map<String, dynamic>? context,
  }) async {
    _ensureInitialized();
    try {
      return await _client.getBooleanValue(
        flagKey,
        defaultValue,
        targetingKey: context?['targetingKey'] as String?,
        evaluationContext: context,
      );
    } catch (e) {
      throw DSIntelliToggleErrorMapper.mapError(e);
    }
  }

  /// Fetches the value of a feature flag as a string.
  ///
  /// [flagKey]: The unique identifier for the flag.
  /// [defaultValue]: Value returned if flag cannot be evaluated.
  /// [context]: Optional evaluation context for targeting.
  @override
  Future<String> getStringFlag(
    String flagKey, {
    String defaultValue = '',
    Map<String, dynamic>? context,
  }) async {
    _ensureInitialized();
    try {
      return await _client.getStringValue(
        flagKey,
        defaultValue,
        targetingKey: context?['targetingKey'] as String?,
        evaluationContext: context,
      );
    } catch (e) {
      throw DSIntelliToggleErrorMapper.mapError(e);
    }
  }

  /// Fetches the value of a feature flag as a number.
  ///
  /// [flagKey]: The unique identifier for the flag.
  /// [defaultValue]: Value returned if flag cannot be evaluated.
  /// [context]: Optional evaluation context for targeting.
  @override
  Future<num> getNumberFlag(
    String flagKey, {
    num defaultValue = 0,
    Map<String, dynamic>? context,
  }) async {
    _ensureInitialized();
    try {
      return await _client.getIntegerValue(
        flagKey,
        defaultValue.toInt(),
        targetingKey: context?['targetingKey'] as String?,
        evaluationContext: context,
      );
    } catch (e) {
      throw DSIntelliToggleErrorMapper.mapError(e);
    }
  }

  /// Fetches the value of a feature flag as JSON.
  ///
  /// [flagKey]: The unique identifier for the flag.
  /// [defaultValue]: Value returned if flag cannot be evaluated.
  /// [context]: Optional evaluation context for targeting.
  @override
  Future<Map<String, dynamic>> getJsonFlag(
    String flagKey, {
    Map<String, dynamic> defaultValue = const {},
    Map<String, dynamic>? context,
  }) async {
    _ensureInitialized();
    try {
      final result = await _client.getObjectValue(
        flagKey,
        defaultValue,
        targetingKey: context?['targetingKey'] as String?,
        evaluationContext: context,
      );
      return result as Map<String, dynamic>? ?? defaultValue;
    } catch (e) {
      throw DSIntelliToggleErrorMapper.mapError(e);
    }
  }

  /// Evaluates a feature flag and returns detailed evaluation results.
  ///
  /// [flagKey]: The unique identifier for the flag.
  /// [context]: Optional evaluation context for targeting.
  @override
  Future<DSFeatureFlagEvaluationResult> evaluateFlag(
    String flagKey, {
    Map<String, dynamic>? context,
  }) async {
    _ensureInitialized();
    try {
      final result = await _intelliToggleProvider.getBooleanFlag(
        flagKey,
        false,
      );

      return DSFeatureFlagEvaluationResult(
        value: result.value,
        reason: result.reason.toString(),
        variant: result.variant ?? '',
      );
    } catch (e) {
      throw DSIntelliToggleErrorMapper.mapError(e);
    }
  }
}