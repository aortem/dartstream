// Always Import the Utillities Base Class
import 'ds_utilities_base.dart';

//Import Other Packages

class StringUtilities extends DSUtilitiesBase {
  String capitalizeFirstLetter(String input) {
    // Implementation...
    return input[0].toUpperCase() + input.substring(1);
  }

  @override
  void log(String message) {
    // Optionally override the base log method
    super.log(message); // Call the base method
    // Additional logging logic specific to string utilities, if needed
  }
}
