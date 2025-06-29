// lib/src/cors/ds_origin_checker.dart

/// A function that returns true if a given origin is allowed.
typedef DsOriginChecker = bool Function(String origin);

/// Allows any origin.
bool dsOriginAllowAll(String origin) => true;

/// Allows only the exact strings or regex patterns in [allowed].
DsOriginChecker dsOriginOneOf(List<String> allowed) {
  return (origin) {
    for (final pattern in allowed) {
      if (pattern.startsWith('^') || pattern.contains(r'\.')) {
        // Treat as regex
        if (RegExp(pattern).hasMatch(origin)) return true;
      } else if (origin == pattern) {
        // Exact match
        return true;
      }
    }
    return false;
  };
}
