// Always Import the Utillities Base Class
import 'ds_utilities_base.dart';

//Import Other Packages
import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashPassword(String password) {
  return sha256.convert(utf8.encode(password)).toString();
}

String sanitizeForSQL(String input) {
  // Simple example. Consider using prepared statements or a library instead.
  return input.replaceAll("'", "''");
}
