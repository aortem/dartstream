// lib/ds_shelf.dart
library ds_enhanced_authentication_features;

//The Enhanced library features include SDKs, trusted third party integrations.

//IMPORTS

//BASE MIDDLEWARE LIBRIARIES - USE ONLY ONE

//The Base DS and Custom Shelf Library.
import 'package:ds_shelf/ds_shelf.dart';
//import 'package:ds_custom/ds_custom.dart';

//---AUTHENTICATION---

//Amazon Cognito
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';

//Firebase Admin SDK

//Azure Identity SDK

//------------------------

//EXPORTS

//---AUTHENTICATION---

//Amazon Cognito
export 'package:amazon_cognito_identity_dart_2/cognito.dart'; // Amazon SDK Package
export 'package:amazon_cognito_identity_dart_2/sig_v4.dart'; // Amazon SDK Package

//Firebase Admin SDK

/* 

export 'package:ds_firebase_admin_SDK'; // Azure SDK Package
export 'package:ds_firebase_admin_SDK'; // Firebase Admin SDK Package

//Azure Identity SDK

export 'package:ds_azure_identity_dart'; // Azure SDK Package
export 'package:ds_azure_identity_dart'; // Firebase Admin SDK Package 

*/
