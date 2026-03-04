# DartStream

## DS Enhanced Packages

DS Enhanced Packages are any packages that are not built by the core dart team.  Many of these packages greatly enhance functionality to the Dart core.

Third party packages are broken up into several different categories depending on the use case:

- authentication
- database
- file-storage
- google_dev
- payments
- general_third_party

## Package Modularity

Take note that the enchanced package has more flexibility than the standard or tools package, given the number of possible dependency permutations.  We have given users the option to import the full enchanced  library, or choose custom modules based on the groups listed above.


## Package Conflicts and Aliases

As expected, package conflicts and naming conventions may exist.  Dartstream attempts to build a consist base class across all third party packages with proper DS prefix in order to ensure smooth interoperability with the core dart packages and dartstream custom packages.

We carefully curate packages that we believe may be of significant value to our users and provide a smooth experience.  

## Licensing

All Dartstream packages are licensed under BSD-3, except for the *services packages*, which uses the ELv2 license, and the *Dartstream SDK packages*, which are licensed from third party software Aortem Inc. In short, this means that you can, without limitation, use any of the client packages in your app as long as you do not offer the SDK's or services as a cloud service to 3rd parties (this is typically only relevant for cloud service providers).  See the [LICENSE](LICENSE.md) file for more details.


## Enhance with DartStream

We hope DartStream helps you to efficiently build and scale your server-side applications. Join our growing community and start contributing to the ecosystem today!

---

## Contributing Plugins to Enhanced

### Overview

The `enhanced/` package welcomes third-party integrations and optional modules. External developers and partners can contribute integrations that extend DartStream's core functionality.

### Directory Structure
```
enhanced/
├── lib/
│   ├── core/
│   │   ├── authentication/      # Auth providers
│   │   ├── database/            # Database integrations
│   │   ├── file_storage/        # Storage providers
│   │   ├── google_dev/          # Google integrations
│   │   └── payments/            # Payment processors
│   ├── extensions/
│   └── overrides/
├── pubspec.yaml
└── README.md
```

### Creating a Plugin

#### 1. Required Files

Every plugin must include:
```
your_plugin_name/
├── lib/
│   └── your_plugin_entry.dart
├── manifest.yaml              # Required
├── pubspec.yaml              # Required
└── README.md                 # Recommended
```

#### 2. Manifest File (`manifest.yaml`)

Each plugin **must** include a `manifest.yaml`:
```yaml
name: ds_your_plugin_name
version: "0.0.1"
description: "Brief description of your plugin."
dependencies:
  - "Core >=0.0.1"
entry_point: "lib/ds_your_plugin_entry.dart"
level: thirdParty
```

**Required Fields:**
- `name`: Plugin identifier (follow naming conventions below)
- `version`: Semantic version
- `description`: Brief description
- `dependencies`: DartStream dependencies
- `entry_point`: Main entry file
- `level`: `thirdParty` for external plugins, `core` for first-class

#### 3. Naming Conventions

**File Naming:**
- Core framework: `ds_*.dart` (e.g., `ds_auth_manager.dart`)
- Enhanced plugins: `enhanced_*.dart` or `ds_plugin_*.dart`
- Custom: `custom_*.dart`

**Class Naming:**
- PascalCase matching file name
- Example: `ds_auth_manager.dart` → `DSAuthManager`

**Method/Variable Naming:**
- Methods: camelCase (e.g., `getBooleanFlag()`)
- Variables: lowerCamelCase (e.g., `defaultValue`)
- Constants: SCREAMING_SNAKE_CASE (e.g., `DEFAULT_TIMEOUT`)

#### 4. Code Standards

**Documentation:**
```dart
/// Abstract class for managing feature flags.
abstract class DSFeatureFlagProvider {
  /// Fetches the value of a feature flag as a boolean.
  Future<bool> getBooleanFlag(String flagKey, {bool defaultValue = false});
}
```

**Interface-Driven Design:**
```dart
class StripePaymentProvider implements DSPaymentProvider {
  // Implementation
}
```

**Dependency Injection:**
```dart
class CustomAuthProvider implements DSAuthProvider {
  final String apiUrl;
  
  CustomAuthProvider({required this.apiUrl});
}
```

**Testing:**
Include `test/` directory with unit and integration tests.

#### 5. Plugin Discovery

Plugins are auto-discovered when running:
```bash
dart run bin/generate_registry.dart
```

This registers all plugins with valid `manifest.yaml` files in `dartstream_registry.yaml`.

### 6. Using the CLI

After creating your plugin with a `manifest.yaml`, use the DartStream CLI to manage it:

**Discover and sync plugins:**
```bash
# Generate registry from all manifest.yaml files
dart run bin/generate_registry.dart

# Sync discovered plugins to config
dart run bin/sync_extensions.dart
```

**List all available plugins:**
```bash
dart bin/ds_cli.dart list-extensions
```

**Enable a plugin:**
```bash
dart bin/ds_cli.dart enable-plugin <plugin_name>
```

**Disable a plugin:**
```bash
dart bin/ds_cli.dart disable-plugin <plugin_name>
```

**Example workflow:**
```bash
# After adding your plugin to enhanced/
dart run bin/generate_registry.dart
dart run bin/sync_extensions.dart
dart bin/ds_cli.dart list-extensions
dart bin/ds_cli.dart enable-plugin my_custom_auth
```

### Submission Process

1. Test your plugin thoroughly
2. Follow naming conventions and coding standards
3. Include comprehensive documentation
4. Ensure manifest.yaml is complete
5. Submit via pull request

### Support

For plugin development questions:
- Review existing plugins in `standard/` for examples
- Check main DartStream documentation
- Contact the DartStream team