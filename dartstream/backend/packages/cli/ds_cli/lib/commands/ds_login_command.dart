import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';

class DSLoginCommand extends Command<void> {
  @override
  final name = 'login';

  @override
  final description = 'Authenticate this machine with a DartStream API token.';

  final Directory? configDirectory;

  DSLoginCommand({this.configDirectory}) {
    argParser
      ..addOption(
        'token',
        help: 'DartStream API token to save for CLI workflows.',
      )
      ..addOption(
        'api-url',
        defaultsTo: 'https://api.dartstream.io',
        help: 'DartStream API base URL.',
      );
  }

  @override
  Future<void> run() async {
    final token = _tokenFromArgs();
    if (token == null || token.isEmpty) {
      throw UsageException('Missing token. Pass --token <token>.', usage);
    }

    final configDir = _resolveConfigDirectory();
    await configDir.create(recursive: true);

    final credentialsFile = File(
      '${configDir.path}${Platform.pathSeparator}credentials.json',
    );
    final payload = <String, dynamic>{
      'token': token,
      'apiUrl': argResults?['api-url'] as String,
      'savedAt': DateTime.now().toUtc().toIso8601String(),
    };

    await credentialsFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert(payload),
    );

    stdout.writeln('DartStream CLI login saved.');
  }

  String? _tokenFromArgs() {
    final token = argResults?['token'] as String?;
    if (token != null && token.trim().isNotEmpty) return token.trim();

    final envToken = Platform.environment['DARTSTREAM_TOKEN'];
    if (envToken != null && envToken.trim().isNotEmpty) {
      return envToken.trim();
    }

    return null;
  }

  Directory _resolveConfigDirectory() {
    if (configDirectory != null) return configDirectory!;

    final override = Platform.environment['DARTSTREAM_CONFIG_DIR'];
    if (override != null && override.trim().isNotEmpty) {
      return Directory(override.trim());
    }

    if (Platform.isWindows) {
      final appData = Platform.environment['APPDATA'];
      if (appData != null && appData.trim().isNotEmpty) {
        return Directory(
          '${appData.trim()}${Platform.pathSeparator}DartStream',
        );
      }
    }

    final home =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    if (home == null || home.trim().isEmpty) {
      return Directory('.dartstream');
    }

    return Directory('${home.trim()}${Platform.pathSeparator}.dartstream');
  }
}
