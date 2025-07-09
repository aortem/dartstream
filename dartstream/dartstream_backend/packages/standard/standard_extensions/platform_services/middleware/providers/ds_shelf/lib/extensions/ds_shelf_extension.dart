// Import Top Level Package
import '../ds_shelf.dart';
//Import other core packages

abstract class DSStaticFileHanlder extends DSShelfCore {}

extension StaticFileHandler on Router {
  void serveStaticFiles(String path) {
    // Implementation for serving static files
  }
}
