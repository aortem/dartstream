//This is a default no-operation implementation to use if no provider is selected.

// extensions/feature_flags/noop_feature_flag_manager.dart
import 'feature_flag_manager.dart';

class NoOpFeatureFlagManager implements FeatureFlagManager {
  @override
  Future<bool> isEnabled(String feature) async => false;

  @override
  Future<void> setFeatureState(String feature, bool enabled) async {
    // No operation, just a placeholder
  }
}
