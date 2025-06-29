// lib/src/utilities/ds_shelf_string_utils.dart

/// Capitalize the first letter of a string.
String dsShelfCapitalize(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}
