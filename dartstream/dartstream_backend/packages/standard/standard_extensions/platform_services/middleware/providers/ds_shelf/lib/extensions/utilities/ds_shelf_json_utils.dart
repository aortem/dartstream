// lib/src/utilities/ds_shelf_json_utils.dart
import 'dart:convert';

/// Parse a JSON string into a Map.
Map<String, dynamic> dsShelfParseJson(String jsonStr) {
  return json.decode(jsonStr) as Map<String, dynamic>;
}

/// Convert an object to its JSON string representation.
String dsShelfToJson(Object data) {
  return json.encode(data);
}
