// ds_standard_core.dart

import 'package:ds_standard_features/utilities/ds_di_container.dart';
import 'package:ds_standard_features/utilities/ds_services.dart';

/// Core project configuration class that stores user choices.
class ProjectConfig {
  String projectName;
  String projectType;
  String cloudVendor;
  String authProvider;
  String middleware;
  String framework;
  String database;
  String ciCdTool;
  List<String> tools;

  ProjectConfig({
    required this.projectName,
    this.projectType = 'New Project',
    this.cloudVendor = 'Local',
    this.authProvider = '',
    this.middleware = 'Dartstream Middleware',
    this.framework = '',
    this.database = '',
    this.ciCdTool = '',
    this.tools = const [],
  });

  /// Saves the current configuration to a local storage or file.
  void saveConfig() {
    // Logic to save the configuration locally or in a file.
  }

  Map<String, dynamic> toJson() => {
        'projectName': projectName,
        'projectType': projectType,
        'cloudVendor': cloudVendor,
        'authProvider': authProvider,
        'middleware': middleware,
        'framework': framework,
        'database': database,
        'ciCdTool': ciCdTool,
        'tools': tools,
      };
}

/// Handles the core project setup based on CLI inputs.
class DartstreamCore {
  final ProjectConfig config;
  final DartstreamDIContainer diContainer;
  final DartstreamServices services;

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
    var loader = MiddlewareLoader();
    var middleware = loader.load(middlewareType);
    middleware.setup();
    print("Middleware '$middlewareType' registered.");
  }

  /// Sets up CI/CD tools based on user choice.
  void setupCiCdTool(String tool) {
    var ciCdConfigurator = CiCdConfigurator();
    ciCdConfigurator.setupCiCd(tool);
    print("CI/CD tool '$tool' setup complete.");
  }

  /// Loads user-selected tools such as Security, Performance, etc.
  void loadTools() {
    var toolCustomizer = ToolCustomizer();
    toolCustomizer.loadTools(config.tools);
    print("Selected tools loaded: ${config.tools.join(', ')}");
  }

  /// Shows a preview of the user's configuration and confirms the setup.
  bool confirmSetup() {
    var preview = SetupPreview();
    preview.display(config);
    return preview.confirm();
  }
}

/// Factory for cloud provider setup.
class CloudProviderFactory {
  CloudProvider getProvider(String vendor) {
    switch (vendor) {
      case 'Google Cloud':
        return GoogleCloudProvider();
      case 'AWS':
        return AWSProvider();
      case 'Azure':
        return AzureProvider();
      default:
        throw Exception('Unknown cloud provider');
    }
  }
}

/// Factory for selecting an authentication SDK.
class AuthProviderFactory {
  AuthProvider getAuthProvider(String provider) {
    switch (provider) {
      case 'Firebase Authentication':
        return FirebaseAuthProvider();
      case 'AWS Cognito':
        return AWSCognitoProvider();
      case 'Azure Active Directory':
        return AzureADProvider();
      default:
        throw Exception('Unknown authentication provider');
    }
  }
}

/// Middleware loader based on CLI choice.
class MiddlewareLoader {
  DartstreamMiddleware load(String middlewareType) {
    switch (middlewareType) {
      case 'Dartstream Middleware':
        return DartstreamDefaultMiddleware();
      case 'Shelf Middleware':
        return ShelfMiddleware();
      case 'Custom Middleware':
        // Load custom middleware, potentially from an extensions folder.
        return CustomMiddleware();
      default:
        throw Exception('Unsupported middleware type');
    }
  }
}

/// CI/CD configurator for user-selected tools.
class CiCdConfigurator {
  void setupCiCd(String tool) {
    switch (tool) {
      case 'GitHub Actions':
        print("Setting up GitHub Actions workflows...");
        break;
      case 'GitLab CI':
        print("Setting up GitLab CI workflows...");
        break;
      case 'Custom Script':
        print("Setting up a custom CI/CD script...");
        break;
      default:
        throw Exception('Unsupported CI/CD tool');
    }
  }
}

/// Tool customization for optional features like Security or Performance monitoring.
class ToolCustomizer {
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
class SetupPreview {
  void display(ProjectConfig config) {
    print('Review your selections:');
    print('- Project Name: ${config.projectName}');
    print('- Cloud Vendor: ${config.cloudVendor}');
    print('- Authentication SDK: ${config.authProvider}');
    print('- Middleware: ${config.middleware}');
    print('- Framework: ${config.framework}');
    print('- Database: ${config.database}');
    print('- CI/CD: ${config.ciCdTool}');
    print('- Custom Tools: ${config.tools.join(', ')}');
  }

  /// Confirms the setup, awaiting user input.
  bool confirm() {
    print('Confirm setup? (y/n)');
    // Capture user input and return true or false based on response.
    return true;
  }
}
