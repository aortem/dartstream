# DartStream

## Core Testing Packages

Enhance your testing workflow with these integrated core testing packages included in DartStream:

- **test**: Provides a solid foundation for writing and running unit and integration tests in Dart.
- **mockito and mocktail**: Facilitate the creation of mock objects. While Mockito is used for non-null safe code, Mocktail offers full support for Dart's null safety.
- **build_runner**: A powerful tool for generating code, running source generation, and more.
- **build_test**: Assists in testing code that uses build_runner for generation.
- **coverage**: Measures how much code is covered by tests, helping to ensure thorough testing of your application.

### Using the Testing Packages

To effectively use these packages, include them in your `pubspec.yaml` under `dev_dependencies`. Here is a basic guide to get you started:

```yaml
dev_dependencies:
  test: ^latest
  mockito: ^latest
  mocktail: ^latest
  build_runner: ^latest
  build_test: ^latest
  coverage: ^latest
```

## Licensing

All Dartstream packages are licensed under BSD-3, except for the *services packages*, which uses the ELv2 license, and the *Dartstream SDK packages*, which are licensed from third party software Aortem Inc. In short, this means that you can, without limitation, use any of the client packages in your app as long as you do not offer the SDK's or services as a cloud service to 3rd parties (this is typically only relevant for cloud service providers).  See the [LICENSE](LICENSE.md) file for more details.


## Enhance with DartStream

We hope DartStream helps you to efficiently build and scale your server-side applications. Join our growing community and start contributing to the ecosystem today!