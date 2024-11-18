//This file defines the core feature flag interface.
// extensions/feature_flags/feature_flag_manager.dart
abstract class FeatureFlagManager {
  Future<bool> isEnabled(String feature);
  Future<void> setFeatureState(String feature, bool enabled);
}
