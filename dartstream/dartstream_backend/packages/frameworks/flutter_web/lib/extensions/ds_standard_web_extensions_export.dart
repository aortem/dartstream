/// Export file for Flutter Web Extensions
/// Provides centralized exports for all extension-related components

library ds_standard_web_extensions;

// Export main extensions implementation
export 'ds_standard_web_extensions.dart';

// Export extension base classes
export 'ds_standard_web_extensions.dart'
    show WebExtension, WidgetExtension, ServiceExtension, WebExtensionState;

// Export example extensions
export 'ds_standard_web_extensions.dart' show AuthWidgetExtension;

// Export providers from standard features
//export 'package:ds_standard_features/ds_standard_features.dart';

// Export Flutter types needed by extensions
export 'package:flutter/material.dart' show Widget, BuildContext, Container;

// Export needed interfaces
export '../core/ds_standard_web_core.dart' show Disposable;
