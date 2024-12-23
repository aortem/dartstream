/// Export file for Flutter Web Utilities
/// Provides centralized exports for all utility functions

library ds_standard_web_utilities;

// Export main utilities implementation
export 'ds_standard_web_utilities.dart';

// Export utility classes and extensions
export 'ds_standard_web_utilities.dart'
    show DSWebUtilities, WebContextExtensions;

// Export Flutter types needed by utilities
export 'package:flutter/material.dart' show BuildContext, MediaQuery, Size;
