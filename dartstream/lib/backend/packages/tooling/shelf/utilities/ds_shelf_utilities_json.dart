// Import Top Level Package
import '../ds_shelf.dart' as shelf; //Coverage for shelf
import '../ds_shelf.dart'; //Coverage for other packages

//Import other core packages
import 'dart:convert';

abstract class DL extends DSUtilitiesBase {}

Map<String, dynamic> parseJson(String jsonStr) {
  return json.decode(jsonStr) as Map<String, dynamic>;
}

String toJson(Map<String, dynamic> jsonObject) {
  return json.encode(jsonObject);
}
