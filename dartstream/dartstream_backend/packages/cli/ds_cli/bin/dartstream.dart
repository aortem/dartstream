import 'package:args/command_runner.dart';
import 'dart:io';
import '../lib/commands/ds_init_command.dart';
import '../lib/commands/ds_configure_command.dart';
import '../lib/commands/ds_enable_extension_command.dart';
import '../lib/commands/ds_disable_extension_command.dart';
import '../lib/commands/ds_setup_command.dart';
import '../lib/commands/ds_discovery_command.dart';
import '../lib/commands/ds_generate_command.dart';
import '../lib/commands/ds_validate_command.dart';
import '../lib/commands/ds_extensions_command.dart';
import '../lib/commands/ds_list_command.dart';

// Auto-sync manifest and registry before running commands
Future<void> syncManifestAndRegistry() async {
  print('Syncing manifest and registry...');

  // Run sync_manifest.dart
  final syncResult = await Process.run('dart', [
    'run',
    '../../../bin/sync_manifest.dart',
  ]);

  if (syncResult.exitCode != 0) {
    print('Warning: Manifest sync failed: ${syncResult.stderr}');
  }

  // Run generate_registry.dart
  final genResult = await Process.run('dart', [
    'run',
    '../../../bin/generate_registry.dart',
  ]);

  if (genResult.exitCode != 0) {
    print('Warning: Registry generation failed: ${genResult.stderr}');
  }
}

void main(List<String> args) async {
  // Auto-sync before running any command
  await syncManifestAndRegistry();

  final runner =
      CommandRunner<void>(
          'dartstream',
          'Dartstream CLI - Full-stack framework for Dart',
        )
        ..addCommand(DSInitCommand())
        ..addCommand(DSConfigureCommand())
        ..addCommand(DSEnableExtensionCommand())
        ..addCommand(DSDisableExtensionCommand())
        ..addCommand(DSSetupCommand())
        ..addCommand(DSDiscoveryCommand())
        ..addCommand(DSGenerateCommand())
        ..addCommand(DSValidateCommand())
        ..addCommand(DSExtensionsCommand())
        ..addCommand(DSListCommand());

  try {
    await runner.run(args);
  } on UsageException catch (e) {
    print(e);
    exit(64);
  } catch (e) {
    print('An unexpected error occurred: $e');
    exit(1);
  }
}
