import 'package:args/command_runner.dart';
import 'dart:io';

class DSAddMiddlewareCommand extends Command {
  @override
  final name = 'add_middleware';
  @override
  final description = 'Add middleware to the Flutter project';

  DSAddMiddlewareCommand() {
    argParser.addOption('type', abbr: 't', allowed: ['ds_shelf', 'ds_custom'], help: 'Type of middleware to add');
    argParser.addOption('iotio', abbr: 'i', help: 'Select IOTIO');
  }

  @override
  void run() {
    final type = argResults?['type'];
    final iotio = argResults?['iotio'];

    if (type == null || !(type == 'ds_shelf' || type == 'ds_custom')) {
      print('Invalid middleware type. Use --type=ds_shelf or --type=ds_custom');
      return;
    }

    if (iotio != null) {
      print('IOTIO selected: $iotio');
    }

    addMiddleware(type);
  }

  void addMiddleware(String type) {

 final flutterProjectDir = Directory.current.path;

  // Check if the 'lib' directory exists
  final libDir = Directory('$flutterProjectDir/lib');
  if (!libDir.existsSync()) {
    print('Error: lib directory not found in $flutterProjectDir/');
    return;
  }

  // Path to the main.dart file
  final mainDartFile = File('$flutterProjectDir/lib/main.dart');

  if (!mainDartFile.existsSync()) {
    print('Error: main.dart not found in $flutterProjectDir/lib/');
    return;
  }




    // // Locate the Flutter project directory
    // final flutterProjectDir = Directory.current.path;

    // // Path to the main.dart file
    // final mainDartFile = File('$flutterProjectDir/lib/main.dart');

    if (!mainDartFile.existsSync()) {
      print('Error: main.dart not found in $flutterProjectDir/lib/');
      return;
    }

    // Read the contents of main.dart
    final mainDartContent = mainDartFile.readAsStringSync();

    // Depending on the middleware type, add the necessary import and code
    String updatedContent="";
    if (type == 'ds_shelf') {
      updatedContent = mainDartContent.replaceFirst(
        'void main() {',
        '''
import 'package:ds_shelf/ds_shelf.dart';

void main() {
  final handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(_echoRequest);

  shelf.serve(handler, 'localhost', 8080);
}

Response _echoRequest(Request request) =>
    Response.ok('Request for "\${request.url}"');
''');
    } else if (type == 'ds_custom') {
      updatedContent = mainDartContent.replaceFirst(
        'void main() {',
        '''
import 'package:ds_custom_middleware/ds_custom_middleware.dart';

void main() {
  final customMiddleware = CustomMiddleware();
  customMiddleware.initialize();

  runApp(MyApp());
}
''');
    }

    // Write the updated content back to main.dart
    mainDartFile.writeAsStringSync(updatedContent);
    print('Middleware $type has been added to main.dart');
  }
}