// Import Top Level Package
import 'package:ds_shelf/ds_shelf_test.dart' as shelf; //Coverage for shelf
import 'package:ds_shelf/ds_shelf_test.dart'; //Coverage for other packages

//Import other core packages

String joinPaths(String base, String path) {
  return base.endsWith('/') ? '$base$path' : '$base/$path';
}
