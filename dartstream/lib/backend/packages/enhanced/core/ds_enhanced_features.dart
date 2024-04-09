// lib/ds_shelf.dart
library ds_enhanced_features;

//The Ehanced features include SDKs, trusted third party integrations.

//AUTHENTICATION 


//DATABASE 


//FILE STORAGE 


//PAYMENTS

// Export Enhanced feature so users don't have to import them separately
export 'package:http_multi_server/http_multi_server.dart';
export 'package:shelf/shelf.dart';
export 'package:shelf_packages_handler/shelf_packages_handler.dart';
export 'package:shelf_proxy/shelf_proxy.dart';
export 'package:shelf_router/shelf_router.dart';
export 'package:shelf_static/shelf_static.dart';
export 'package:shelf_test_handler/shelf_test_handler.dart';
export 'package:web_socket_channel/web_socket_channel.dart';

//Export our Enhanced Feture Libraries

AUTHENTICATION PACKAGES

export 'core/authentication/amazon_cognito_sdk.dart'; // Amazon SDK Package
export 'core/authentication/azure_identity_sdk.dart'; // Azure SDK Package
export 'core/authentication/azure_identity_sdk.dart'; // Firebase Admin SDK Package

DATABASE PACKAGES
export 'core/ds_shelf_core_export.dart'; // Exporting your core classes
export 'api/ds_shelf_api_export.dart'; // Exporting your api classes
export 'extensions/ds_shelf_extensions_export.dart'; // Exporting your extensions classes
export 'utilities/ds_shelf_utilities_export.dart'; // Exporting your utility classes
export 'overrides/ds_shelf_overrides_export.dart'; // Exporting your overrides classes

FILESTORE PACKAGES

PAYMENTS PACKAGES

//Test part - to be removed

//part 'api/ds_shelf_api.dart';
//part 'core/ds_shelf_core.dart';
//part 'extensions/ds_shelf_extension.dart';
//part 'overrides/ds_overrides.dart';
//part 'utilities/ds_utilities_base.dart'; */


