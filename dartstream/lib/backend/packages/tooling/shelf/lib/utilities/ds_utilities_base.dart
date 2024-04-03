//This is our utility base class

import 'package:ds_shelf/ds_shelf.dart';
//import 'ds_utilities.dart';

abstract class DSUtilitiesBase extends DSShelfCore {
  // Example of a shared utility method
  void log(String message) {
    print("Utility Log: $message");
  }

  // You might also define abstract methods or interfaces here that
  // all extending utility classes should implement.
}
