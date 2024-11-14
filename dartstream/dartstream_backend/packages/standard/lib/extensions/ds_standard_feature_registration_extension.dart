import 'package:ds_standard_features/extensions/ds_lifecycle_hooks.dart';
import 'package:ds_standard_features/utilities/ds_di_container.dart';
import 'package:ds_standard_features/utilities/ds_services.dart';

/// The base interface for extensions within the Dartstream framework.
/// Provides lifecycle methods, dependency injection, and feature-specific configurations.
abstract class DartstreamFeatureExtension {
  // Core lifecycle methods

  /// Initializes the extension, setting up necessary configurations.
  Future<void> initialize();

  /// Executes the primary functionality of the extension.
  Future<void> execute();

  /// Cleans up resources when the extension is disposed.
  Future<void> dispose();

  // Metadata properties

  /// The name of the extension.
  String get name;

  /// The version of the extension.
  String get version;

  /// Specifies compatible Dartstream version range for this extension.
  String get compatibleVersion;

  /// Lists other required extensions or dependencies.
  List<String> get requiredExtensions;

  /// A description of the extension.
  String get description;

  /// URL to documentation or resources related to the extension.
  String get documentationUrl;

  // Configuration and Dependency Injection

  /// Configures the extension using key-value settings.
  void configure(Map<String, dynamic> settings);

  /// Injects core services or dependencies.
  void registerServices(DartstreamServices services);

  // Event lifecycle hooks

  /// Hook called when Dartstream starts.
  void onStart();

  /// Hook called when Dartstream pauses.
  void onPause();

  /// Hook called when Dartstream resumes.
  void onResume();

  // Error Handling

  /// Handles errors within the extension.
  bool handleError(Object error);

  /// Reports errors with additional context.
  void reportError(Object error, {String context = ''});

  // Event listener support

  /// Registers a callback for specific Dartstream events.
  void registerEventListener(String event, Function callback);

  // Inter-extension Communication

  /// Sends a command to other registered extensions.
  void sendCommand(String command, {Map<String, dynamic>? parameters});

  /// Receives commands sent by other extensions.
  void onCommandReceived(String command, Map<String, dynamic> parameters);

  // Permissions

  /// Requests specific permissions required by the extension.
  List<String> requestPermissions();

  /// Checks if the extension has the specified permission.
  bool hasPermission(String permission);

  // Status and health checks

  /// Returns the current operational status of the extension.
  String get status;

  /// Runs a health check to verify the extension’s functionality.
  Future<bool> runHealthCheck();

  // Logging

  /// Logs messages or errors with optional level (e.g., info, warning, error).
  void log(String message, {String level = 'info'});

  // Advanced features

  /// Indicates if the extension should be lazily loaded.
  bool get isLazy;

  /// Loads the extension on-demand if it is lazily loaded.
  Future<void> load();

  /// Injects dependencies through a Dependency Injection container.
  void injectDependencies(DartstreamDIContainer container);

  /// Adds custom lifecycle hooks for specific use cases.
  void addLifecycleHook(LifecycleHook hook);

  /// Refreshes configuration dynamically without restarting the extension.
  Future<void> refreshConfig();

  // Advanced extension functionalities

  /// Assigns priority for execution order (lower numbers execute first).
  int get priority;

  /// Sets scoped configurations, useful for multi-tenant environments.
  void setScope(String tenantId, Map<String, dynamic> config);

  /// Resolves and loads dependencies automatically.
  Future<void> resolveDependencies();

  /// Manages data migrations from previous versions for backward compatibility.
  Future<void> migrateFrom(String previousVersion);

  /// Provides caching support for frequently accessed data.
  T getCachedData<T>(String key);

  /// Sets cached data for performance optimization.
  void setCachedData<T>(String key, T value);
}
