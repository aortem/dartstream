class PathParser {
  /// Parses the path into a map of parameters.
  Map<String, String> parsePath(String path) {
    final parts = path.split('/');
    final params = <String, String>{};

    // Start at index 1 to skip the first part (empty string)
    for (var i = 1; i < parts.length; i += 2) {
      if (i + 1 < parts.length) {
        params[parts[i]] = parts[i + 1];
      }
    }
    return params;
  }
}
