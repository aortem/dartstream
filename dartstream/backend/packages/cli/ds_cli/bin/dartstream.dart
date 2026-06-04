import 'dart:io';

import 'package:args/command_runner.dart';

import '../lib/commands/ds_configure_command.dart';
import '../lib/commands/ds_disable_extension_command.dart';
import '../lib/commands/ds_discovery_command.dart';
import '../lib/commands/ds_enable_extension_command.dart';
import '../lib/commands/ds_extensions_command.dart';
import '../lib/commands/ds_generate_command.dart';
import '../lib/commands/ds_init_command.dart';
import '../lib/commands/ds_list_command.dart';
import '../lib/commands/ds_login_command.dart';
import '../lib/commands/ds_setup_command.dart';
import '../lib/commands/ds_validate_command.dart';

Future<void> syncManifestAndRegistry() async {
  final syncManifestScript = File('../../../bin/sync_manifest.dart');
  final generateRegistryScript = File('../../../bin/generate_registry.dart');
  if (!syncManifestScript.existsSync() ||
      !generateRegistryScript.existsSync()) {
    return;
  }

  print('Syncing manifest and registry...');

  final syncResult = await Process.run('dart', [
    'run',
    syncManifestScript.path,
  ]);

  if (syncResult.exitCode != 0) {
    print('Warning: Manifest sync failed: ${syncResult.stderr}');
  }

  final genResult = await Process.run('dart', [
    'run',
    generateRegistryScript.path,
  ]);

  if (genResult.exitCode != 0) {
    print('Warning: Registry generation failed: ${genResult.stderr}');
  }
}

Future<void> main(List<String> args) async {
  if (!_skipsManifestSync(args)) {
    await syncManifestAndRegistry();
  }

  final runner =
      CommandRunner<void>(
          'dartstream',
          'DartStream CLI - Full-stack framework for Dart',
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
        ..addCommand(DSListCommand())
        ..addCommand(DSLoginCommand());

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

bool _skipsManifestSync(List<String> args) {
  if (args.isEmpty) return true;

  final normalizedArgs = args.map((arg) => arg.toLowerCase()).toSet();
  if (normalizedArgs.contains('--help') || normalizedArgs.contains('-h')) {
    return true;
  }

  return args.first == 'help' || args.first == 'login';
}
