import 'package:args/command_runner.dart';

import '../../../ds_shelf/lib/ds_shelf.dart';

class DSSelectMiddleWareCommand extends Command {
  @override
  final name = 'create-project';
  @override
  final description = 'Creates a new project with selected middleware.';

  DSSelectMiddleWareCommand() {
    argParser
      ..addOption(
        'name',
        abbr: 'n',
        help: 'The name of the project.',
      )
      ..addOption(
        'middleware',
        abbr: 'm',
        allowed: ['dsCustom', 'dsShelf'],
        help: 'The middleware to use (dsCustom, dsShelf)',
      );
  }

  @override
  void run() {
    final projectName = argResults?['name'] as String?;
    if (projectName == null || projectName.isEmpty) {
      print('A project name is required.');
      return;
    }

    final middleware = argResults?['middleware'] as String?;
    if (middleware == null || !['dsCustom', 'dsShelf'].contains(middleware)) {
      print('Invalid middleware option. Choose from dsCustom or dsShelf.');
      return;
    }

    print('Creating project: $projectName with $middleware middleware...');
    createProject(projectName, middleware);
    print(
        'Project "$projectName" created successfully with $middleware middleware.');
  }

  void createProject(String projectName, String chosenMiddleware) async {
    switch (chosenMiddleware) {
      case 'dsCustom':
        break;
      case 'dsShelf':
        final shelfMiddleware = DSShelfCore();

        break;
      default:
        throw ArgumentError('Unexpected middleware option: $chosenMiddleware');
    }

    print('Middleware used: $chosenMiddleware');
  }
}

// Main function to run the CLI
void main(List<String> arguments) {
  final runner = CommandRunner('cli', 'A CLI tool for creating projects')
    ..addCommand(DSSelectMiddleWareCommand());

  runner.run(arguments).catchError((error) {
    print(error);
  });
}
