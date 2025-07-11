//import 'package:ds_custom_middleware/ds_custom_middleware.dart';

// import 'dart:io';
import 'dart:async';
// import 'dart:math';
import 'package:test/test.dart';
// import 'package:ds_tools_testing/ds_tools_testing.dart';
// import 'package:dartstream/commands/lib/ds_init_command.dart';
// import 'package:dartstream/commands/lib/ds_list_command.dart';
// import 'package:dartstream/commands/lib/ds_setup_command.dart';
// import 'package:dartstream/commands/lib/ds_validate_command.dart';
// import 'package:dartstream/commands/lib/ds_extensions_command.dart';
// import 'package:dartstream/commands/lib/ds_configure_command.dart';
// import 'package:dartstream/commands/lib/ds_discovery_command.dart';
import '../../dartstream_backend/packages/cli/ds_cli/lib/commands/ds_init_command.dart';
import '../../dartstream_backend/packages/cli/ds_cli/lib/commands/ds_list_command.dart';
import '../../dartstream_backend/packages/cli/ds_cli/lib/commands/ds_setup_command.dart';
import '../../dartstream_backend/packages/cli/ds_cli/lib/commands/ds_validate_command.dart';
import '../../dartstream_backend/packages/cli/ds_cli/lib/commands/ds_extensions_command.dart';
import '../../dartstream_backend/packages/cli/ds_cli/lib/commands/ds_configure_command.dart';
import '../../dartstream_backend/packages/cli/ds_cli/lib/commands/ds_discovery_command.dart';

void main() {
  group('Dartstream CLI tests', () {
    test('Discovery command', () {
      var printedMessages = <String>[];

      Zone.current
          .fork(
            specification: ZoneSpecification(
              print: (self, parent, zone, line) {
                printedMessages.add(line);
              },
            ),
          )
          .run(() {
            DSDiscoveryCommand().run();
          });

      var showedStarting = printedMessages.any(
        (text) => text.contains("Starting extension discovery"),
      );

      var showedExtensionsDirectory = printedMessages.any(
        (text) => text.contains("Extensions directory"),
      );

      var showedRegistryFile = printedMessages.any(
        (text) => text.contains("Registry file"),
      );

      var showedDiscoveryComplete = printedMessages.any(
        (text) => text.contains("Discovery complete. Registered extensions"),
      );

      var showedHooksExecuted = printedMessages.any(
        (text) => text.contains("hooks executed successfully"),
      );

      expect(showedStarting, true);
      expect(showedExtensionsDirectory, true);
      expect(showedRegistryFile, true);
      expect(showedDiscoveryComplete, true);
      expect(showedHooksExecuted, true);
    });

    test('Configure command', () {
      var printedMessages = <String>[];

      Zone.current
          .fork(
            specification: ZoneSpecification(
              print: (self, parent, zone, line) {
                printedMessages.add(line);
              },
            ),
          )
          .run(() {
            String readLineCallback() {
              return "1";
            }

            DSConfigureCommand().execute(readLineCallback: readLineCallback);
          });

      var showedConfiguringProject = printedMessages.any(
        (text) => text.contains("Configuring project"),
      );

      var showedConfigurationUpdated = printedMessages.any(
        (text) => text.contains("Configuration updated"),
      );

      expect(showedConfiguringProject, true);
      expect(showedConfigurationUpdated, true);
    });

    test('Extensions command', () {
      var printedMessages = <String>[];

      Zone.current
          .fork(
            specification: ZoneSpecification(
              print: (self, parent, zone, line) {
                printedMessages.add(line);
              },
            ),
          )
          .run(() {
            DSExtensionsCommand().run();
          });

      var showedListingExtensions = printedMessages.any(
        (text) => text.contains("Listing extensions from the registry"),
      );

      var showedExtensionsDirectory = printedMessages.any(
        (text) => text.contains("Extensions directory:"),
      );

      var showedRegistryFile = printedMessages.any(
        (text) => text.contains("Registry file"),
      );

      var didFinish = printedMessages.any((text) {
        return text.contains("Total:") ||
            text.contains("Registered Extensions") ||
            text.contains("No extensions discovered or registered");
      });

      expect(showedListingExtensions, true);
      expect(showedExtensionsDirectory, true);
      expect(showedRegistryFile, true);
      expect(didFinish, true);
    });

    test('Validate command', () {
      var printedMessages = <String>[];

      Zone.current
          .fork(
            specification: ZoneSpecification(
              print: (self, parent, zone, line) {
                printedMessages.add(line);
              },
            ),
          )
          .run(() {
            DSValidateCommand().run();
          });

      var showedValidating = printedMessages.any(
        (text) => text.contains("Validating extensions"),
      );

      var showedExtensionsDirectory = printedMessages.any(
        (text) => text.contains("Extensions directory:"),
      );

      var showedRegistryFile = printedMessages.any(
        (text) => text.contains("Registry file"),
      );

      var didFinish = printedMessages.any((text) {
        return text.contains("All extensions validated successfully") ||
            text.contains("Some extensions failed validation") ||
            text.contains("No extensions discovered for validation");
      });

      expect(showedValidating, true);
      expect(showedExtensionsDirectory, true);
      expect(showedRegistryFile, true);
      expect(didFinish, true);
    });

    test('Setup command', () {
      var printedMessages = <String>[];

      Zone.current
          .fork(
            specification: ZoneSpecification(
              print: (self, parent, zone, line) {
                printedMessages.add(line);
              },
            ),
          )
          .run(() {
            String readLineCallback() {
              return "1";
            }

            DSSetupCommand().execute(readLineCallback: readLineCallback);
          });

      var showedProjectComponents = printedMessages.any(
        (text) => text.contains("Setting up project components"),
      );

      var showedMiddleware = printedMessages.any(
        (text) => text.contains("Middleware:"),
      );

      var showedCICD = printedMessages.any((text) => text.contains("CI/CD:"));

      var showedTools = printedMessages.any((text) => text.contains("Tools:"));

      expect(showedProjectComponents, true);
      expect(showedMiddleware, true);
      expect(showedCICD, true);
      expect(showedTools, true);
    });

    test('Init command', () {
      var printedMessages = <String>[];

      Zone.current
          .fork(
            specification: ZoneSpecification(
              print: (self, parent, zone, line) {
                printedMessages.add(line);
              },
            ),
          )
          .run(() {
            String readLineCallback() {
              return "test answer";
            }

            DSInitCommand().execute(readLineCallback: readLineCallback);
          });

      var didInitialize = printedMessages.any(
        (text) => text.contains("initialized with version"),
      );

      expect(didInitialize, true);
    });

    test('List command', () {
      var printedMessages = <String>[];

      Zone.current
          .fork(
            specification: ZoneSpecification(
              print: (self, parent, zone, line) {
                printedMessages.add(line);
              },
            ),
          )
          .run(() {
            DSListCommand().run();
          });

      var foundAvailableCommands = printedMessages.any(
        (text) => text.contains("Available commands:"),
      );

      var foundInitCommand = printedMessages.any(
        (text) => text.contains("Initialize a new Dartstream project"),
      );

      var foundConfigCommand = printedMessages.any(
        (text) => text.contains(
          "Configure core project components like cloud provider and framework",
        ),
      );

      var foundEnableExtensionCommand = printedMessages.any(
        (text) => text.contains("Enables a specified extension"),
      );

      var foundDisableExtensionCommand = printedMessages.any(
        (text) => text.contains("Disables a specified extension"),
      );

      var foundSetupCommand = printedMessages.any(
        (text) =>
            text.contains("Set up middleware, CI/CD, and additional tools"),
      );

      var foundDiscoverCommand = printedMessages.any(
        (text) => text.contains(
          "Discovers, validates, and dynamically registers extensions",
        ),
      );

      var foundGenerateCommand = printedMessages.any(
        (text) =>
            text.contains("Generate project files based on the configuration"),
      );

      var foundValidateCommand = printedMessages.any(
        (text) => text.contains(
          "Validates all discovered extensions for manifest correctness and dependency compatibility",
        ),
      );

      var foundExtensionsCommand = printedMessages.any(
        (text) =>
            text.contains("Lists all discovered and registered extensions"),
      );

      var foundListCommand = printedMessages.any(
        (text) => text.contains("Lists all available commands for Dartstream"),
      );

      expect(foundAvailableCommands, true);
      expect(foundInitCommand, true);
      expect(foundConfigCommand, true);
      expect(foundEnableExtensionCommand, true);
      expect(foundDisableExtensionCommand, true);
      expect(foundSetupCommand, true);
      expect(foundDiscoverCommand, true);
      expect(foundGenerateCommand, true);
      expect(foundValidateCommand, true);
      expect(foundExtensionsCommand, true);
      expect(foundListCommand, true);
    });
  });
}
