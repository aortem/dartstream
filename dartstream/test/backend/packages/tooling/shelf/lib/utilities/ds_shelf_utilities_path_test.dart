// Import Top Level Package
//Coverage for shelf
//Coverage for other packages

//Import other core packages

String joinPaths(String base, String path) {
  return base.endsWith('/') ? '$base$path' : '$base/$path';
}
