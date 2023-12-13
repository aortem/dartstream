## Our team is creating brilliant and engaging products. Come Join The Journey.

<div class="text-center" align="center">

![dartstream_docs_logo](docs/images/docs_logo.png)

_dartstream is a MBAAS platform for building cross-platform applications<br> using Flutter/Dart and other languages._

**[dartstream.dev](https://dartstream.dev)**

[Contributing Guidelines](CONTRIBUTING.md) . [Submit an Issue](https://github.com/dartapps/apps/dartstream-web-app/issues) . [Architecture](docs/ARCHITECTURE.md)

</div>

---

## Documentation

Get started with dartstream fundamentals and explore architecture on our documentation.

- [Onboarding Started](docs/ONBOARDING.md) - Tutorial
- [Contributing Guidelines](CONTRIBUTING.md)
- [Fixup Commits](docs/FIXUP_COMMITS.md)

### Apps

- [dartstream API](apps/dartstream_api/README.md) - Internal API's tp power the platform governed by Google's API gateway https://cloud.google.com/api-gateway
- [dartstream Web App](apps/dartstream_app/README.md) - The dartstream Multi-Tenant Application Interface
- [Assembly Line](apps/assembly_line/README.md) - Dart Framework As Service Components which combines Core, Core Plus, Auth Spoke, Database Spoke, Packages and other libraries

### Core Packages

List of public packages.  Mainly Google packages (Flutter or Dart) or pre-vetted/trusted packages (ie. Provider/Navigator 2.0).  Available to all users. Keeps it close to core.      

- [Google Dev](packages/google-dev/README.md)
- [Flutter Dev](packages/flutter-dev/README.md)
- [Dart_dev](packages/dart-dev/README.md)
- [Tools_Dart_dev](packages/tools-dart_dev/README.md)
- [State Management](packages/state-management/README.md)
- [Route Navigation](packages/light-engine/README.md)
- [Payments](packages/payments/README.md)

### Plus Packages

List of custom packages. All packages here are hosted in a private repo and served via a roating time base checked "Dart Pub Token" that can only be accessed via kub's secrets/yaml.  All Packages here are either custom built or cloned from an existing package and refactored.  Packages here are an essential part of dartstream.

- [TBD](TBD)

### Modules

List of Dart Server Framework modules and Interface modules built for the platform.  Accessibility to these modules and the features within the modules for each user type is controlled by RBAC.   

- [Authentication Spoke](TBD)
- [Database Spoke](TBD)
- [Drag and Drop Builder](TBD)
- [DartPad Editor](packages/dartpad-editor/README.md)
- [DartPad Server](packages/dartpad-server/README.md)
- [IDE](packages/ide/README.md)



### Contributing Guidelines

Read through [contributing guidelines](CONTRIBUTING.md) to learn about submission process, coding rules and more.

### Code of Conduct

Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md).

___

&copy; Copyright 2023. Dartstream.