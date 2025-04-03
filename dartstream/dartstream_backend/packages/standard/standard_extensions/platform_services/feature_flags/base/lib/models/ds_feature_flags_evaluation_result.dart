/*Models like DSFeatureFlagEvaluationResult are part of the feature flag's 
/core design and are directly used by providers and managers.*/

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
