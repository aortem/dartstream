import '../standard_features/ds_standard_features.dart';
import '../extensions/discovery/ds_discovery.dart';
import '../extensions/events/base/ds_event_manager.dart';

/// Core project configuration class that stores user choices.
class DartstreamProjectConfig {
  String projectName;
  String projectType;
  String authProvider;
  String middleware;
  String framework;
  String database;
  List<String> tools;

  DartstreamProjectConfig({
    required this.projectName,
    this.projectType = 'New Project',
    this.authProvider = '',
    this.middleware = 'Dartstream Middleware',
    this.framework = '',
    this.database = '',
    this.tools = const [],
  });

  /// Saves the current configuration to a local storage or file.
  void saveConfig() {
    // Logic to save the configuration locally or in a file.
    print('Configuration saved.');
  }

  /// Converts the configuration to JSON format.
  Map<String, dynamic> toJson() => {
        'projectName': projectName,
        'projectType': projectType,
        'authProvider': authProvider,
        'middleware': middleware,
        'framework': framework,
        'database': database,
        'tools': tools,
      };
}

/// Handles the core project setup based on CLI inputs.
class DartstreamCore {
  final DartstreamProjectConfig config;
  final ExtensionRegistry _extensionRegistry;
  final EventManager eventManager;

  DartstreamCore({
    required this.config,
    required this.eventManager,
    required ExtensionRegistry extensionRegistry,
  }) : _extensionRegistry = extensionRegistry;

  /// Initializes core setup for Dartstream, including project configuration and services.
  Future<void> initializeCore() async {
    print('Initializing Dartstream Core for project: ${config.projectName}');

    // Load auth provider
    final authFactory = ds_AuthProviderFactory(_extensionRegistry);
    final authProvider = authFactory.getAuthProvider(config.authProvider);
    print('Loaded authentication provider: ${config.authProvider}');

    // Register middleware
    final middlewareLoader = ds_MiddlewareLoader(_extensionRegistry);
    middlewareLoader.load(config.middleware);

    // Load tools
    final toolCustomizer = ds_ToolCustomizer(_extensionRegistry);
    toolCustomizer.loadTools(config.tools);

    print('Dartstream Core initialized successfully.');
  }

  /// Configures the core settings and persists them.
  void configureCore(Map<String, dynamic> settings) {
    config.saveConfig();
    print("Configuration saved.");
  }

  /// Publishes an event using the EventManager.
  void publishEvent(String event, dynamic data) {
    eventManager.publish(event, data);
    print("Event published: $event");
  }

  /// Subscribes to an event using the EventManager.
  void subscribeToEvent(String event, void Function(dynamic) callback) {
    eventManager.subscribe(event, callback);
    print("Subscribed to event: $event");
  }
}

/// Factory for selecting an authentication provider dynamically.
class ds_AuthProviderFactory {
  final ExtensionRegistry _extensionRegistry;

  ds_AuthProviderFactory(this._extensionRegistry);

  ds_AuthProvider getAuthProvider(String providerName) {
    final authExtensions = _extensionRegistry.extensions.where((ext) {
      return ext.name.contains('Auth') &&
          ext.description.contains(providerName);
    });

    if (authExtensions.isEmpty) {
      throw Exception(
          'No matching authentication provider found for $providerName');
    }

    final entryPoint = authExtensions.first.entryPoint;
    return _loadAuthProvider(entryPoint);
  }

  ds_AuthProvider _loadAuthProvider(String entryPoint) {
    // Placeholder: Replace with actual dynamic loading logic.
    print('Loading auth provider from $entryPoint');
    return ds_DefaultAuthProvider(); // Replace with actual provider implementation.
  }
}

/// Middleware loader based on CLI choice and extension discovery.
class ds_MiddlewareLoader {
  final ExtensionRegistry _extensionRegistry;

  ds_MiddlewareLoader(this._extensionRegistry);

  void load(String middlewareType) {
    final middlewareExtensions = _extensionRegistry.extensions.where((ext) {
      return ext.name.contains('Middleware') &&
          ext.description.contains(middlewareType);
    });

    if (middlewareExtensions.isEmpty) {
      throw Exception('No matching middleware found for $middlewareType');
    }

    final entryPoint = middlewareExtensions.first.entryPoint;
    print('Loading middleware from $entryPoint');
    // Placeholder: Replace with actual middleware dynamic loading logic.
  }
}

/// Tool customization for optional features like Security or Performance monitoring.
class ds_ToolCustomizer {
  final ExtensionRegistry _extensionRegistry;

  ds_ToolCustomizer(this._extensionRegistry);

  void loadTools(List<String> selectedTools) {
    for (var tool in selectedTools) {
      final toolExtensions = _extensionRegistry.extensions.where((ext) {
        return ext.name.contains('Tool') && ext.description.contains(tool);
      });

      if (toolExtensions.isEmpty) {
        print('No matching tool found for $tool');
        continue;
      }

      final entryPoint = toolExtensions.first.entryPoint;
      print('Loading tool: $tool from $entryPoint');
      // Placeholder: Replace with actual tool dynamic loading logic.
    }
  }
}

/// Displays and confirms the setup choices.
class ds_SetupPreview {
  void display(DartstreamProjectConfig config) {
    print('Review your selections:');
    print('- Project Name: ${config.projectName}');
    print('- Authentication SDK: ${config.authProvider}');
    print('- Middleware: ${config.middleware}');
    print('- Framework: ${config.framework}');
    print('- Database: ${config.database}');
    print('- Custom Tools: ${config.tools.join(', ')}');
  }

  /// Confirms the setup, awaiting user input.
  bool confirm() {
    print('Confirm setup? (y/n)');
    // Capture user input (mocked as "yes" for now).
    return true;
  }
}

/// Core project configuration class that stores user choices.
class DartstreamProjectConfig {
  String projectName;
  String projectType;
  String authProvider;
  String middleware;
  String framework;
  String database;
  List<String> tools;

  DartstreamProjectConfig({
    required this.projectName,
    this.projectType = 'New Project',
    this.authProvider = '',
    this.middleware = 'Dartstream Middleware',
    this.framework = '',
    this.database = '',
    this.tools = const [],
  });

  /// Saves the current configuration to a local storage or file.
  void saveConfig() {
    // Logic to save the configuration locally or in a file.
  }

  Map<String, dynamic> toJson() => {
        'projectName': projectName,
        'projectType': projectType,
        'authProvider': authProvider,
        'middleware': middleware,
        'framework': framework,
        'database': database,
        'tools': tools,
      };
}

/// Handles the core project setup based on CLI inputs.
class DartstreamCore {
  final DartstreamProjectConfig config;
  final ds_DartstreamDIContainer diContainer;
  final ds_DartstreamServices services;

  DartstreamCore({
    required this.config,
    required this.diContainer,
    required this.services,
  });

  /// Initializes core setup for Dartstream, including project configuration and services.
  Future<void> initializeCore() async {
    print('Initializing Dartstream Core with project: ${config.projectName}');
    // Additional setup logic (e.g., load dependencies, prepare services)
  }

  /// Configures the core settings and persists them.
  void configureCore(Map<String, dynamic> settings) {
    config.saveConfig();
    print("Configuration saved.");
  }

  /// Registers selected middleware based on user choice.
  void registerMiddleware(String middlewareType) {
    var loader = ds_MiddlewareLoader();
    var middleware = loader.load(middlewareType);
    middleware.setup();
    print("Middleware '$middlewareType' registered.");
  }

  /// Loads user-selected tools such as Security, Performance, etc.
  void loadTools() {
    var toolCustomizer = ds_ToolCustomizer();
    toolCustomizer.loadTools(config.tools);
    print("Selected tools loaded: ${config.tools.join(', ')}");
  }

  /// Shows a preview of the user's configuration and confirms the setup.
  bool confirmSetup() {
    var preview = ds_SetupPreview();
    preview.display(config);
    return preview.confirm();
  }
}

/// Factory for selecting an authentication SDK.
class ds_AuthProviderFactory {
  ds_AuthProvider getAuthProvider(String provider) {
    switch (provider) {
      case 'Firebase Authentication':
        return ds_FirebaseAuthProvider();
      case 'AWS Cognito':
        return ds_AWSCognitoProvider();
      case 'Azure Active Directory':
        return ds_AzureADProvider();
      default:
        throw Exception('Unknown authentication provider');
    }
  }
}

/// Middleware loader based on CLI choice.
class ds_MiddlewareLoader {
  ds_DartstreamMiddleware load(String middlewareType) {
    switch (middlewareType) {
      case 'Dartstream Middleware':
        return ds_DartstreamDefaultMiddleware();
      case 'Shelf Middleware':
        return ds_ShelfMiddleware();
      case 'Custom Middleware':
        // Load custom middleware, potentially from an extensions folder.
        return ds_CustomMiddleware();
      default:
        throw Exception('Unsupported middleware type');
    }
  }
}

/// Tool customization for optional features like Security or Performance monitoring.
class ds_ToolCustomizer {
  void loadTools(List<String> selectedTools) {
    if (selectedTools.contains('Security Tools')) {
      print("Loading security tools...");
      // Implement security tool loading logic (e.g., Sentry)
    }
    if (selectedTools.contains('Performance Tools')) {
      print("Loading performance monitoring tools...");
      // Implement performance monitoring logic
    }
    // Add more tools as needed
  }
}

/// Displays and confirms the setup choices.
class ds_SetupPreview {
  void display(DartstreamProjectConfig config) {
    print('Review your selections:');
    print('- Project Name: ${config.projectName}');
    print('- Authentication SDK: ${config.authProvider}');
    print('- Middleware: ${config.middleware}');
    print('- Framework: ${config.framework}');
    print('- Database: ${config.database}');
    print('- Custom Tools: ${config.tools.join(', ')}');
  }

  /// Confirms the setup, awaiting user input.
  bool confirm() {
    print('Confirm setup? (y/n)');
    // Capture user input and return true or false based on response.
    return true;
  }
}
