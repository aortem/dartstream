// Import Top Level Package
//Coverage for shelf
import 'package:ds_shelf/ds_shelf_test.dart'; //Coverage for other packages

//Import other core packages

abstract class DSStaticFileHanlder extends DSShelfCore {}

extension StaticFileHandler on Router {
  void serveStaticFiles(String path) {
    // Implementation for serving static files
  }
}
