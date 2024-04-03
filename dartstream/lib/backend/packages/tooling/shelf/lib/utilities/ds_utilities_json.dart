// Always Import the Utillities Base Class
import 'ds_utilities_base.dart';

//Import Other Packages

import 'dart:convert';

Map<String, dynamic> parseJson(String jsonStr) {
  return json.decode(jsonStr) as Map<String, dynamic>;
}

String toJson(Map<String, dynamic> jsonObject) {
  return json.encode(jsonObject);
}
