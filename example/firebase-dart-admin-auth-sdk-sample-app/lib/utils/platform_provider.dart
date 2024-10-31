import 'dart:io';

String getPlatformId() {
  if (Platform.isAndroid) {
    return 'google.com';
  }
  if (Platform.isIOS) {
    return 'apple.com';
  }
  return 'google.com';
}
