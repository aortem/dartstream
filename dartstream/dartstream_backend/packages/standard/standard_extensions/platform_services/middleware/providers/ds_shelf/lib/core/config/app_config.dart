import 'package:dotenv/dotenv.dart';
import '../../extensions/cors/ds_shelf_origin_checker.dart';

/// Holds global settings loaded from your environment.
class AppConfig {
  /// A list of allowed CORS origins.
  final List<String> _allowedOrigins;
  final DsShelfOriginChecker originChecker;

  /// Exposes the parsed origins if you ever need them directly:
  List<String> get allowedOrigins => List.unmodifiable(_allowedOrigins);

  AppConfig._(this._allowedOrigins)
    : originChecker = dsShelfOriginOneOf(_allowedOrigins);

  /// Loads ALLOWED_ORIGINS from .env as a comma-separated list.
  factory AppConfig.load() {
    final env = DotEnv()..load();
    final raw = env['ALLOWED_ORIGINS'] ?? '';
    final origins = raw
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    // Ensure type safety: List<String>
    final List<String> parsedOrigins = origins.cast<String>();
    return AppConfig._(parsedOrigins);
  }
}
