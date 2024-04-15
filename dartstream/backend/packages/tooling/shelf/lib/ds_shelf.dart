// lib/ds_shelf.dart
library ds_shelf;

//The Shelf Core Libraries - Built by the dart team

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_packages_handler/shelf_packages_handler.dart';
import 'package:shelf_proxy/shelf_proxy.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:shelf_test_handler/shelf_test_handler.dart';

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
export 'utilities/ds_shelf_utilities_export.dart'; // Exporting your utility classes
export 'overrides/ds_shelf_overrides_export.dart'; // Exporting your overrides classes


