/// Abstract base class for feature flag providers in DartStream.
/// Ensures a consistent interface across all providers.
abstract class DSFeatureFlagProvider {
  /// Fetches the value of a feature flag as a boolean.
  Future<bool> getBooleanFlag(
    String flagKey, {
    bool defaultValue = false,
    Map<String, dynamic>? context,
  });

  /// Fetches the value of a feature flag as a string.
  Future<String> getStringFlag(
    String flagKey, {
    String defaultValue = '',
    Map<String, dynamic>? context,
  });

  /// Fetches the value of a feature flag as a number.
  Future<num> getNumberFlag(
    String flagKey, {
    num defaultValue = 0,
    Map<String, dynamic>? context,
  });

  /// Fetches the value of a feature flag as JSON.
  Future<Map<String, dynamic>> getJsonFlag(
    String flagKey, {
    Map<String, dynamic> defaultValue = const {},
    Map<String, dynamic>? context,
  });

  /// Evaluates a feature flag and returns detailed results.
  Future<DSFeatureFlagEvaluationResult> evaluateFlag(
    String flagKey, {
    Map<String, dynamic>? context,
  });
}

/// Represents the result of a feature flag evaluation.
class DSFeatureFlagEvaluationResult {
  /// The value of the evaluated feature flag.
  final dynamic value;

  /// The reason for the flag's state (e.g., "default", "targeting_match").
  final String reason;

  /// The variant of the flag (if applicable).
  final String variant;

  /// Constructor for creating an evaluation result.
  DSFeatureFlagEvaluationResult({
    required this.value,
    required this.reason,
    this.variant = '',
  });

  /// Converts the evaluation result to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'reason': reason,
      'variant': variant,
    };
  }

  /// Factory constructor to create a result from JSON.
  factory DSFeatureFlagEvaluationResult.fromJson(Map<String, dynamic> json) {
    return DSFeatureFlagEvaluationResult(
      value: json['value'],
      reason: json['reason'] ?? 'default',
      variant: json['variant'] ?? '',
    );
  }

  @override
  String toString() {
    return 'DSFeatureFlagEvaluationResult(value: $value, reason: $reason, variant: $variant)';
  }
}
