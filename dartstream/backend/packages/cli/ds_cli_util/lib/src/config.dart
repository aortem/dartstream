import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

import './project.dart';

void saveProjectConfig({
  required String name,
  required Map<String, dynamic> content,
}) {
  final configFile = File('${getProjectDir(name).path}/config.yaml');

  var oldContent = YamlMap();

  if (configFile.existsSync()) {
    oldContent = loadYaml(configFile.readAsStringSync());
  } else {
    configFile.createSync();
  }

  final yamlWriter = YamlWriter();

  final yamlDocString = yamlWriter.write({...oldContent, ...content});

  configFile.writeAsStringSync(yamlDocString);
}
