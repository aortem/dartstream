import 'package:ds_feature_flags_base/ds_feature_flag_base_export.dart';
import 'package:ds_flagd_provider/ds_flagd_export.dart';

Future<void> main() async {
  await registerFlagdProvider({
    'host': 'localhost',
    'port': 8013,
  });

  final enabled = await DSFeatureFlagManager.getBooleanFlag(
    'flagd',
    'new-checkout',
    defaultValue: false,
    context: {
      'targetingKey': 'user-123',
      'plan': 'pro',
    },
  );

  print('new-checkout: $enabled');
}
