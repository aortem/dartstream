import 'dart:io';

import 'package:ds_intellitoggle_provider/ds_intellitoggle_export.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('DSIntelliToggleProvider integration', () {
    final clientId = Platform.environment['INTELLITOGGLE_CLIENT_ID'];
    final clientSecret = Platform.environment['INTELLITOGGLE_CLIENT_SECRET'];
    final tenantId = Platform.environment['INTELLITOGGLE_TENANT_ID'];

    final hasCredentials = clientId != null &&
        clientId.isNotEmpty &&
        clientSecret != null &&
        clientSecret.isNotEmpty &&
        tenantId != null &&
        tenantId.isNotEmpty;

    test(
      'can initialize against IntelliToggle sandbox',
      () async {
      final provider = DSIntelliToggleProvider(
        clientId: clientId!,
        clientSecret: clientSecret!,
        tenantId: tenantId!,
        config: DSIntelliToggleConfig.development(),
      );

      await provider.initialize();
      final result =
          await provider.getBooleanFlag('integration-smoke-flag', defaultValue: false);
      expect(result, isA<bool>());
      await provider.shutdown();
      },
      skip: hasCredentials ? false : 'Set INTELLITOGGLE_* env vars to run',
    );
  });
}
