// lib/ds_enchanced_features.dart
library ds_enhanced_features;

//------------------ IMPORTS ------------------

//Import Standard Libraries and Tools
import 'package:ds_standard_features/ds_standard_features.dart';

//DS Shelf and Custom Middleware - Use Only One
import 'package:ds_shelf/ds_shelf.dart';

//import 'package:ds_custom/ds_custom.dart';

//------------------ AUTHENICATION PACKAGES ------------------

//Amazon SDK
//Firebase ADMIN SDK (GCP)
//Azure SDK

//------------------ DATABASE PACKAGES ------------------
import 'package:sqlite3/sqlite3.dart'; // Local development only

// Amazon Database
// GCP Database
// Azure Database

//------------------ FILE_STORAGE PACKAGES ------------------

// Amazon File Storage
// GCP File Storage
// Azure File Storage

//------------------ GENERAL_THIRD_PARTY------------------

//------------------ GOOGLE_DEV PACKAGES ------------------

/*

Welcome to use any of the packages here https://pub.dev/publishers/google.dev/packages 

*/

//------------------ PAYMENTS ------------------

//Stripe
//Paypal

//------------------ EXPORTS ------------------

export 'package:ds_shelf/ds_shelf.dart';
//export 'package:ds_custom/ds_custom.dart';

//THIRD PARTY AUTHENTICATION PACKAGES

export 'package:sqlite3/sqlite3.dart'; // Local development only

export 'core/authentication/amazon_cognito_sdk/ds_amazon_cognito_export.dart';
//export 'api/file.dart';
//export 'extensions/file.dart';
//export 'overrides/file.dart';
