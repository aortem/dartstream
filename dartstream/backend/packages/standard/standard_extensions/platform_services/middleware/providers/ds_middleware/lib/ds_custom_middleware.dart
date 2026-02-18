// lib/ds_custom_middleware.dart

library ds_custom_middleware;

// Export Base DsCustomMiddleware components so users don't have to import them separately
export 'ds_custom_middleware_base.dart';
export 'ds_custom_middleware_interceptor.dart';
export 'app/middleware/ds_custom_core_middleware.dart';
export 'app/models/ds_custom_middleware_model.dart';

// Source Features
export 'src/authorization/ds_authorization.dart';
export 'src/cors/ds_cors_middleware.dart';
export 'src/static_files/ds_static_file_handler.dart';
export 'src/error_handling/ds_error_handler.dart';

// Type Handlers
export 'src/type_handlers/type_handler.dart';
export 'src/type_handlers/type_handler_registry.dart';
export 'src/type_handlers/date_handler.dart';
