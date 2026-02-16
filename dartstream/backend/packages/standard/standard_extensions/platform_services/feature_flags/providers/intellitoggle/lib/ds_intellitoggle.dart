import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ds_feature_flags_base/ds_feature_flag_provider.dart';

/// GoFeatureFlagProvider integrates with the Intellitoggle service.
/// Provides implementation for all DSFeatureFlagProvider methods.
class GoFeatureFlagProvider implements DSFeatureFlagProvider {
  final String apiUrl;
  final String apiKey;

  /// Constructor to initialize the GoFeatureFlagProvider.
  /// [apiUrl]: The base URL for the Intellitoggle API.
  /// [apiKey]: The API key for authentication.
  GoFeatureFlagProvider({required this.apiUrl, required this.apiKey});

  /// Fetches the value of a feature flag as a boolean.
  @override
  Future<bool> getBooleanFlag(
    String flagKey, {
    bool defaultValue = false,
    Map<String, dynamic>? context,
  }) async {
    final result = await evaluateFlag(flagKey, context: context);
    return result.value as bool? ?? defaultValue;
  }

  /// Fetches the value of a feature flag as a string.
  @override
  Future<String> getStringFlag(
    String flagKey, {
    String defaultValue = '',
    Map<String, dynamic>? context,
  }) async {
    final result = await evaluateFlag(flagKey, context: context);
    return result.value as String? ?? defaultValue;
  }

  /// Fetches the value of a feature flag as a number.
  @override
  Future<num> getNumberFlag(
    String flagKey, {
    num defaultValue = 0,
    Map<String, dynamic>? context,
  }) async {
    final result = await evaluateFlag(flagKey, context: context);
    return result.value as num? ?? defaultValue;
  }

  /// Fetches the value of a feature flag as JSON.
  @override
  Future<Map<String, dynamic>> getJsonFlag(
    String flagKey, {
    Map<String, dynamic> defaultValue = const {},
    Map<String, dynamic>? context,
  }) async {
    final result = await evaluateFlag(flagKey, context: context);
    return result.value as Map<String, dynamic>? ?? defaultValue;
  }

  /// Evaluates a feature flag and returns detailed evaluation results.
  @override
  Future<DSFeatureFlagEvaluationResult> evaluateFlag(
    String flagKey, {
    Map<String, dynamic>? context,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/evaluate'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'flagKey': flagKey, 'context': context}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return DSFeatureFlagEvaluationResult(
          value: data['value'],
          reason: data['reason'] ?? 'default',
          variant: data['variant'] ?? '',
        );
      } else {
        print('GoFeatureFlagProvider Error: ${response.body}');
        throw Exception('Failed to evaluate feature flag');
      }
    } catch (e) {
      print('Error in GoFeatureFlagProvider: $e');
      return DSFeatureFlagEvaluationResult(
        value: null,
        reason: 'error',
        variant: '',
      );
    }
  }
}
