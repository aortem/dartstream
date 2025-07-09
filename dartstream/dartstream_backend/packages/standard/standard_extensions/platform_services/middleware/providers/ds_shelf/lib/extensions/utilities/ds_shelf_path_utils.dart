// lib/src/utilities/ds_shelf_path_utils.dart

/// Safely join two URL or file path segments.
String dsShelfJoinPaths(String base, String segment) {
  if (base.endsWith('/')) {
    return '$base\$segment';
  }
  return '\$base/\$segment';
}
