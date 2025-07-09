/// Export file for Flutter Web Overrides
/// Provides centralized exports for all override-related components

library ds_standard_web_overrides;

// Export main overrides implementation
export 'ds_standard_web_overrides.dart';

// Export override implementations
export 'ds_standard_web_overrides.dart'
    show
        DSStandardWebOverrides,
        WebStorageOverride,
        WebNavigationOverride,
        WebUIOverrides;

// Export provider interfaces
export 'ds_standard_web_overrides.dart'
    show StorageProvider, NavigationProvider;

// Export Flutter types needed by overrides
export 'package:flutter/material.dart'
    show
        BuildContext,
        WidgetBuilder,
        Widget,
        Navigator,
        CircularProgressIndicator,
        Center,
        ScaffoldMessenger,
        SnackBar,
        Text;
