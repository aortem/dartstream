// lib/ds_shelf.dart
library ds_shelf;

//The Shelf Core Libraries - Built by the dart team

// Export Base Shelf Component so users don't have to import them separately
export 'package:http_multi_server/http_multi_server.dart';
export 'package:shelf/shelf.dart';
export 'package:shelf_packages_handler/shelf_packages_handler.dart';
export 'package:shelf_proxy/shelf_proxy.dart';
export 'package:shelf_router/shelf_router.dart';
export 'package:shelf_static/shelf_static.dart';
export 'package:shelf_test_handler/shelf_test_handler.dart';
export 'package:web_socket_channel/web_socket_channel.dart';

//Export our Core Libraries
export 'core/ds_shelf_core_export_test.dart'; // Exporting your core classes
export 'api/ds_shelf_api_export_test.dart'; // Exporting your api classes
export 'extensions/ds_shelf_extensions_export_test.dart'; // Exporting your extensions classes
export 'utilities/ds_shelf_utilities_export_test.dart'; // Exporting your utility classes
export 'overrides/ds_shelf_overrides_export_test.dart'; // Exporting your overrides classes

//Test part - to be removed

//part 'api/ds_shelf_api.dart';
//part 'core/ds_shelf_core.dart';
//part 'extensions/ds_shelf_extension.dart';
//part 'overrides/ds_overrides.dart';
//part 'utilities/ds_utilities_base.dart';


