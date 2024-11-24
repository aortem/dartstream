// extensions/feature_flags/launchdarkly_feature_flag_manager.dart
//import 'package:launchdarkly_flutter_client_sdk/launchdarkly_flutter_client_sdk.dart';
import '../base/lib/ds_feature_flag_manager.dart';

class LaunchDarklyFeatureFlagManager implements FeatureFlagManager {
  final LDClient _client;

  LaunchDarklyFeatureFlagManager(this._client);

  @override
  Future<bool> isEnabled(String feature) async {
    return await _client.boolVariation(feature, false);
  }

  @override
  Future<void> setFeatureState(String feature, bool enabled) async {
    // LaunchDarkly may not allow direct setting, handle accordingly.
  }
}
