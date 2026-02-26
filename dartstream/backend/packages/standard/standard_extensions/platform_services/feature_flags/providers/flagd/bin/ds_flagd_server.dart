import 'dart:io';

import 'package:ds_flagd_provider/ds_flagd_export.dart';

Future<void> main() async {
  final host = Platform.environment['FLAGD_HOST'];
  final port = int.tryParse(Platform.environment['FLAGD_PORT'] ?? '8013') ?? 8013;
  final scheme = Platform.environment['FLAGD_SCHEME'] ?? 'http';
  final apiPath =
      Platform.environment['FLAGD_API_PATH'] ?? '/ofrep/v1/evaluate/flags';

  if (host == null || host.isEmpty) {
    print('Missing required environment variable: FLAGD_HOST');
    exit(1);
  }

  await registerFlagdProvider({
    'host': host,
    'port': port,
    'scheme': scheme,
    'apiPath': apiPath,
  });

  print('flagd provider registered for $scheme://$host:$port$apiPath');
}
