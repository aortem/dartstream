# Changelog

## [0.0.1-pre+10] - 2024-08-05

### Remove Dart FFI Package to avoid conflict
- downgrade http parser to 4.0.2 due to collection flutter sdk lock
- added reminder in the pubspec not to update.

## [0.0.1-pre+9] - 2024-08-01

### Remove Dart FFI Package to avoid conflict
- Removed web, matcha, and grpc into their own separate packages.  
- Added back packages like FFI.
- No exported conflicts for the current packages.
- Updated the latest depedencies

## [0.0.1-pre+8] - 2024-07-22

### Remove Dart FFI Package to avoid conflict
- Removing FFI package temporarily to avoid conflicts with dart web.

## [0.0.1-pre+7] - 2024-05-31

### Downgrade Meta Package
- Because every version of flutter from sdk depends on meta 1.11. We have downgraded the version of the meta package to maintain compatibility.

## [0.0.1-pre+6] - 2024-05-30

### Downgrade Meta Package
- Because every version of flutter from sdk depends on meta 1.12. We have downgraded the version of the meta package to maintain compatibility.

## [0.0.1-pre+5] - 2024-04-24

### Remove
- Remove web package from dependencies due to conflicts Resolved package conflicts with libraries using the same methods. Updated alias and methods for web, convert, matcher, and grpc as a result of ambiguous export.

## [0.0.1-pre+4] - 2024-04-24

### Fixed
- Resolved package conflicts with libraries using the same methods. Updated alias and methods for web, convert, matcher, and grpc as a result of ambiguous export.

## [0.0.1-pre+3] - 2024-04-23

### Remove
- Removed Web package from dependency as a result of conflicts.

## [0.0.1-pre+2] - 2024-04-14

### Added
- Adding main package to lib folder.

## [0.0.1-pre+1] - 2024-04-14

### Added
- Adding build numbers to package revisions.

## [0.0.1-pre] - 2024-04-13

### Added
- Initial release with standard features framework functionality.



