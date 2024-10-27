// Primary backend code and foundational classes

// ds_standard_core.dart

// Core setup, factories, and configuration handling.
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

  void saveConfig() {
    // Logic to save the configuration locally or in a file
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

  Future<void> initializeCore() async {
    print('Initializing Dartstream Core with project: ${config.projectName}');
    // Additional setup logic
  }

  void configureCore(Map<String, dynamic> settings) {
    // Configure settings across core and registered components
    config.saveConfig();
  }

  /// Registers selected middleware based on user choice
  void registerMiddleware(String middlewareType) {
    MiddlewareLoader loader = MiddlewareLoader();
    DartstreamMiddleware middleware = loader.load(middlewareType);
    middleware.setup();
  }

  /// Sets up CI/CD tools based on user choice
  void setupCiCdTool(String tool) {
    CiCdConfigurator().setupCiCd(tool);
  }

  /// Loads tools selected by the user (Security, Performance, etc.)
  void loadTools() {
    ToolCustomizer().loadTools(config.tools);
  }

  /// Shows a preview of the user's selections and confirms setup
  bool confirmSetup() {
    SetupPreview().display(config);
    return SetupPreview().confirm();
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

/// Factory for selecting authentication SDK.
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
        // Load custom middleware, potentially from an extensions folder
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
        // Configure GitHub Actions workflows
        break;
      case 'GitLab CI':
        // Configure GitLab CI workflows
        break;
      case 'Custom Script':
        // Set up a custom CI/CD script
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
      // Load security tools like Sentry
    }
    if (selectedTools.contains('Performance Tools')) {
      // Load performance monitoring tools
    }
    // Additional tools...
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

  bool confirm() {
    print('Confirm setup? (y/n)');
    // Collect user input and return true or false based on response
    return true;
  }
}
