// lib/core/config/app_config.dart

import 'package:dotenv/dotenv.dart';
import '../../extensions/cors/ds_shelf_origin_checker.dart';

/// Holds global settings loaded from your environment.
class AppConfig {
  final List _allowedOrigins;
  final DsOriginChecker originChecker;

  AppConfig._(this._allowedOrigins)
    : originChecker = dsOriginOneOf(_allowedOrigins);

  /// Loads ALLOWED_ORIGINS from .env as a comma-separated list.
  factory AppConfig.load() {
    final env = DotEnv()..load();
    final raw = env['ALLOWED_ORIGINS'] ?? '';
    final origins = raw
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    return AppConfig._(origins);
  }
}
