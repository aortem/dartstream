# DartStream

## Core CLi Package

DartStream CLI offers a range of features tailored to support the DartStream framework effectively:

- **Project Initialization**: Quickly scaffold new DartStream projects with pre-configured settings.
- **Build Automation**: Utilize powerful tools like build_runner for code generation and automated tasks.
- **Testing**: Integrated support for unit and integration testing using the test package.
- **Mocking**: Use mockito for legacy projects or mocktail for projects utilizing Dart's null safety features to create mocks and stubs.
- **Code Coverage**: Ensure your tests cover a wide range of your codebase with the coverage package.
- **Streamlined Workflows**: Simplify common tasks with custom scripts and commands tailored for the DartStream environment.

### Installation Of the CLI Package

To install DartStream CLI, you need to have Dart installed on your machine. If you haven't installed Dart yet, you can download it from the official Dart site.

Once Dart is installed, you can install DartStream CLI by running the following command:

```bash
dart pub global activate dartstream_cli
```

### Usage

After installation, you can access DartStream CLI from your terminal or command prompt. Here are some common commands you might find useful:

```bash
dartstream create my_project
```
```bash
dartstream test
```
```bash
dartstream generate
```
```bash
dartstream run
```

## Licensing

All Dartstream packages are licensed under BSD-3, except for the *services packages*, which uses the ELv2 license, and the *Dartstream SDK packages*, which are licensed from third party software Aortem Inc. In short, this means that you can, without limitation, use any of the client packages in your app as long as you do not offer the SDK's or services as a cloud service to 3rd parties (this is typically only relevant for cloud service providers).  See the [LICENSE](LICENSE.md) file for more details.


## Enhance with DartStream"

We hope DartStream helps you to efficiently build and scale your server-side applications. Join our growing community and start contributing to the ecosystem today!