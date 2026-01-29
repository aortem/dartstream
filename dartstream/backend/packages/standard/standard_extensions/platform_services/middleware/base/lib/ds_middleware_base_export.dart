/*The middleware folder contains core middleware logic to perform the following:
- Framework registration.
- Framework configuration.
- Set the default behavior.
- Set the frontend-aware middleware to specify context.
Use a single export file (ds_middleware_base_export.dart) to simplify imports across the framework. */

library ds_middleware_base_export;

export 'ds_middleware_provider.dart';
export 'ds_middleware_manager.dart';
