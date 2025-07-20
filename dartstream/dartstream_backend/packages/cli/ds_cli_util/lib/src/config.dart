import 'dart:io';
import 'dart:convert';
import './project.dart';

void saveConfiguration({
  required String projectName,
  required Map<String, dynamic> content,
}) {
  final configFile = File('${getProjectDir(projectName).path}/config.json');

  var oldContent = <String, dynamic>{};

  if (configFile.existsSync()) {
    oldContent =
        jsonDecode(configFile.readAsStringSync()) as Map<String, dynamic>;
  } else {
    configFile.createSync();
  }

  var newContent = {...oldContent, ...content};

  final configData = JsonEncoder.withIndent('  ').convert(newContent);

  configFile.writeAsStringSync(configData);
}
