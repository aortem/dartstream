/*The auth folder contains core authentication logic and extensions. 
Use a single export file (ds_auth_export.dart) to simplify imports across your framework. */

library ds_auth_export;

export 'ds_auth_provider.dart';
export 'ds_auth_manager.dart';
export '../../providers/google/lib/ds_firebase_auth_provider.dart';
export '../../providers/azure/lib/ds_azure_ad_b2c_auth_provider.dart';
export '../../providers/amazon/lib/ds_cognito_auth_provider.dart';
