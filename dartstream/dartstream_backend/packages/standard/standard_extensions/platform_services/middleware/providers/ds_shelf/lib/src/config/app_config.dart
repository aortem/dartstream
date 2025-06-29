// lib/src/config/app_config.dart

import 'package:dotenv/dotenv.dart';
import '../cors/ds_shelf_origin_checker.dart';

/// Holds global settings loaded from your environment.
class AppConfig {
  /// The raw list of allowed origins (exact strings or regex patterns).
  final List<String> _allowedOrigins;

  /// A function that returns true if a given origin is allowed.
  final DsOriginChecker originChecker;

  AppConfig._(this._allowedOrigins)
    : originChecker = dsOriginOneOf(_allowedOrigins);

  /// Loads settings from your `.env` file (expects an `ALLOWED_ORIGINS` comma-list).
  factory AppConfig.load() {
    // By default, DotEnv() reads the .env in your working directory
    final env = DotEnv()..load();

    // Comma-separated list of allowed origins
    final raw = env['ALLOWED_ORIGINS'] ?? '';
    final origins = raw
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    return AppConfig._(origins);
  }
}
