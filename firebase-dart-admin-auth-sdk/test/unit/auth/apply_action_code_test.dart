/*import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:firebase_dart_admin_auth_sdk/src/action_code_settings_test.dart';

void main() {
  group('ActionCodeSettings', () {
    test('should create an instance with required parameters', () {
      final settings = ActionCodeSettings(url: 'https://example.com');

      expect(settings.url, 'https://example.com');
      expect(settings.handleCodeInApp, false);
      expect(settings.iOSBundleId, isNull);
      expect(settings.androidPackageName, isNull);
      expect(settings.androidInstallApp, isNull);
      expect(settings.androidMinimumVersion, isNull);
      expect(settings.dynamicLinkDomain, isNull);
    });

    test('should correctly convert to map', () {
      final settings = ActionCodeSettings(
        url: 'https://example.com',
        handleCodeInApp: true,
        iOSBundleId: 'com.example.ios',
        androidPackageName: 'com.example.android',
        androidInstallApp: true,
        androidMinimumVersion: '1.0.0',
        dynamicLinkDomain: 'example.page.link',
      );

      final map = settings.toMap();

      expect(map['url'], 'https://example.com');
      expect(map['handleCodeInApp'], true);
      expect(map['iOSBundleId'], 'com.example.ios');
      expect(map['androidPackageName'], 'com.example.android');
      expect(map['androidInstallApp'], true);
      expect(map['androidMinimumVersion'], '1.0.0');
      expect(map['dynamicLinkDomain'], 'example.page.link');
    });
  });

  group('IOSSettings', () {
    test('should create an instance with a bundleId', () {
      final iosSettings = IOSSettings(bundleId: 'com.example.ios');
      expect(iosSettings.bundleId, 'com.example.ios');
    });
  });

  group('AndroidSettings', () {
    test('should create an instance with required parameters', () {
      final androidSettings = AndroidSettings(
        packageName: 'com.example.android',
      );
      expect(androidSettings.packageName, 'com.example.android');
      expect(androidSettings.installApp, isNull);
      expect(androidSettings.minimumVersion, isNull);
    });

    test('should create an instance with optional parameters', () {
      final androidSettings = AndroidSettings(
        packageName: 'com.example.android',
        installApp: true,
        minimumVersion: '2.0.0',
      );
      expect(androidSettings.packageName, 'com.example.android');
      expect(androidSettings.installApp, true);
      expect(androidSettings.minimumVersion, '2.0.0');
    });
  });
}
*/
