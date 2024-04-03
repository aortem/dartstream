// Always Import the Utillities Base Class
import 'ds_utilities_base.dart';

//Import Other Packages

String joinPaths(String base, String path) {
  return base.endsWith('/') ? '$base$path' : '$base/$path';
}
