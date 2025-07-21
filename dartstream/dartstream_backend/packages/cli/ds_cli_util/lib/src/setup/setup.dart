import 'dart:io';
import '../project.dart';
import './examples.dart';

void generateCICDFiles({
  required String projectName,
  required String ciCdChoice,
}) {
  final projectDir = getProjectDir(projectName);

  if (!projectDir.existsSync()) {
    print('Project "$projectName" does not exist. Please initialize it first.');
    return;
  }

  var exampleCiCdContent = '';
  var destinationPath = '';

  if (ciCdChoice == '1') {
    // GitHub Actions
    exampleCiCdContent = githubExample;
    destinationPath = '.github/workflows/main.yml';
  } else if (ciCdChoice == '2') {
    // GitLab CI
    exampleCiCdContent = gitlabExample;
    destinationPath = '.gitlab-ci.yml';
  } else {
    print('Invalid CI/CD choice: $ciCdChoice');
    return;
  }

  var fullDestinationPath = projectDir.path + '/' + destinationPath;

  if (!File(fullDestinationPath).existsSync()) {
    File(fullDestinationPath).createSync(recursive: true);
  }

  File(fullDestinationPath).writeAsStringSync(exampleCiCdContent);
}
