/// Export file for Flutter Web API components
/// This file centralizes all exports from the API layer for easier imports
/// in other parts of the framework.

library ds_standard_web_api;

// Export main API implementation
export 'ds_standard_web_api.dart';

// Export necessary interfaces and types from standard features
export 'package:ds_standard_features/ds_standard_features.dart';

// Export necessary Flutter types
export 'package:flutter/material.dart'
    show BuildContext, Navigator, NavigatorState;

// Export web-specific handlers and configurations
export 'ds_standard_web_api.dart'
    show DSWebRequestHandler, DSWebResponseHandler, DSWebConfig;
