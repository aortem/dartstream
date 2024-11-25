// ds_standard_extensions_export.dart

library ds_standard_extensions;

// Export the main extension system and interfaces
export 'ds_standard_extensions.dart';
export '../lib/extensions/ds_feature_extension.dart';
export '../lib/extensions/ds_lifecycle_hooks.dart';

// Export extension providers
export 'auth/base/lib/ds_auth_manager.dart';
export 'auth/base/lib/ds_auth_provider.dart';
export 'database/ds_firebase_database.dart';
export 'database/ds_mysql_database.dart';
export 'database/ds_postgres_database.dart';
export 'feature_flags/base/lib/ds_feature_flag_manager.dart';
export 'feature_flags/noop_feature_flag_manager.dart';

// Export utility interfaces
export '../utilities/ds_di_container.dart';
export '../utilities/ds_services.dart';
export '../utilities/ds_logging.dart';
export '../utilities/ds_error_handling.dart';
