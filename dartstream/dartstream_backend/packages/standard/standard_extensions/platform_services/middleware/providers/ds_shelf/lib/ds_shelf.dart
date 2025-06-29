// lib/ds_shelf.dart
library ds_shelf;

// Export Base Shelf Component so users don't have to import them separately

export 'package:shelf/shelf.dart';
export 'package:shelf_packages_handler/shelf_packages_handler.dart';
export 'package:shelf_proxy/shelf_proxy.dart';
export 'package:shelf_router/shelf_router.dart';
export 'package:shelf_static/shelf_static.dart';
export 'package:shelf_test_handler/shelf_test_handler.dart';

//Export our Core Libraries

export 'core/ds_shelf_core_export.dart'; // Exporting your core classes
export 'api/ds_shelf_api_export.dart'; // Exporting your api classes
export 'extensions/ds_shelf_extension_export.dart'; // Exporting your extensions classes
export 'src/utilities/ds_shelf_utilities_export.dart'; // Exporting your utility classes
export 'overrides/ds_shelf_overrides_export.dart'; // Exporting your overrides classes

//Export our Config Libraries

export 'src/config/app_config.dart';

//Export our CORS Libraries

export 'src/cors/ds_shelf_cors_middleware.dart';

//Export our Utilities Libraries

export 'src/utilities/ds_shelf_base_utils.dart';
export 'src/utilities/ds_shelf_file_utils.dart';
export 'src/utilities/ds_shelf_json_utils.dart';
export 'src/utilities/ds_shelf_middleware_utils.dart';
export 'src/utilities/ds_shelf_path_utils.dart';
export 'src/utilities/ds_shelf_request_utils.dart';
export 'src/utilities/ds_shelf_response_utils.dart';
export 'src/utilities/ds_shelf_security_utils.dart';
export 'src/utilities/ds_shelf_string_utils.dart';
