// Import Top Level Package
//Coverage for shelf
//Coverage for other packages

//Import other core packages
import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashPassword(String password) {
  return sha256.convert(utf8.encode(password)).toString();
}

String sanitizeForSQL(String input) {
  // Simple example. Consider using prepared statements or a library instead.
  return input.replaceAll("'", "''");
}
