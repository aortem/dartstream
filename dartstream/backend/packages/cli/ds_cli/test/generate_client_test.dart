import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:test/test.dart';

import '../lib/commands/ds_generate_command.dart';

void main() {
  group('generate --type client', () {
    test('creates a client package from OpenAPI JSON', () async {
      final tempDir = Directory.systemTemp.createTempSync(
        'dartstream_generate_client_test_',
      );
      addTearDown(() {
        if (tempDir.existsSync()) {
          tempDir.deleteSync(recursive: true);
        }
      });

      final specFile = File('${tempDir.path}/openapi.json');
      specFile.writeAsStringSync('''
{
  "openapi": "3.0.0",
  "info": { "title": "Metrics API", "version": "1.0.0" },
  "servers": [{ "url": "https://api.example.com" }],
  "paths": {
    "/metrics": {
      "get": {
        "operationId": "listMetrics",
        "summary": "List metrics"
      }
    },
    "/metrics/{id}": {
      "get": {
        "operationId": "getMetricById",
        "summary": "Get one metric"
      }
    }
  }
}
''');

      final outputDir = Directory('${tempDir.path}/generated_clients');
      final runner = CommandRunner<void>('dartstream', 'test runner')
        ..addCommand(DSGenerateCommand());

      await runner.run([
        'generate',
        '--type',
        'client',
        '--name',
        'Metrics',
        '--spec',
        specFile.path,
        '--output',
        outputDir.path,
      ]);

      final packageDir = Directory('${outputDir.path}/ds_metrics_client');
      expect(packageDir.existsSync(), isTrue);

      final pubspec = File('${packageDir.path}/pubspec.yaml');
      final clientFile = File('${packageDir.path}/lib/src/metrics_client.dart');
      final barrel = File('${packageDir.path}/lib/ds_metrics_client.dart');
      final generatedTest = File(
        '${packageDir.path}/test/metrics_client_test.dart',
      );

      expect(pubspec.existsSync(), isTrue);
      expect(clientFile.existsSync(), isTrue);
      expect(barrel.existsSync(), isTrue);
      expect(generatedTest.existsSync(), isTrue);

      final clientContent = clientFile.readAsStringSync();
      expect(clientContent.contains('class DSMetricsClient'), isTrue);
      expect(
        clientContent.contains('Future<DSClientResponse> listMetrics'),
        isTrue,
      );
      expect(
        clientContent.contains('Future<DSClientResponse> getMetricById'),
        isTrue,
      );
    });
  });
}
