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
  print('Syncing manifest and registry...');

  final syncResult = await Process.run('dart', [
    'run',
    '../../../bin/sync_manifest.dart',
  ]);

  if (syncResult.exitCode != 0) {
    print('Warning: Manifest sync failed: ${syncResult.stderr}');
  }

  final genResult = await Process.run('dart', [
    'run',
    '../../../bin/generate_registry.dart',
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
  if (args.isEmpty) return false;
  return args.first == 'login';
}
