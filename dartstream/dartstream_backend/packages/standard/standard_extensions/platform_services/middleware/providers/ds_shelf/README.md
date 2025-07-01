# DartStream

## DS Standard Packages

DS Standard packages allow you to utilize core dart features maintained by the Dart team.  The depdendencies remain largely unmodified.  Dartstream extends the built-in classes and methods, therefore allowing developers the greatest composition flexibility when building their applications.

---

## Shelf Middleware Integration

DartStream provides a set of reusable Shelf middleware out of the box, so you can compose logging, CORS, authentication, rate-limiting, and more in a familiar pipeline style. Simply wire them into your `DSShelfCore` (or plain `Pipeline`) in the order that makes sense for your app.

### Available Middleware

| Middleware         | Import Path                                       | Description                                                  |
| ------------------ | ------------------------------------------------- | ------------------------------------------------------------ |
| **Logging**        | `package:ds_shelf_core/ds_shelf_core.dart`        | `logRequests()` logs each request path, method, and timing.  |
| **CORS**           | `package:your_package/extensions/cors.dart`       | `dsOriginOneOf(origins)` only allows cross-origins you list. |
| **API-Key Auth**   | `package:your_package/extensions/auth.dart`       | `apiKeyAuth(headerName, validator)` validates API keys.      |
| **Rate Limiting**  | `package:your_package/extensions/rate_limit.dart` | `rateLimit(perMinute)` caps requests per client/IP.          |
| **Custom Headers** | `package:your_package/extensions/utilities.dart`  | Helpers for injecting or sanitizing headers.                 |

> *Note: replace `your_package` with your actual package name.*

### Quickstart

```dart
import 'dart:io';
import 'package:ds_shelf/ds_shelf.dart'      as shelf;
import 'package:shelf_router/shelf_router.dart';
import 'package:your_package/config/app_config.dart';
import 'package:your_package/extensions/cors.dart';
import 'package:your_package/extensions/auth.dart';
import 'package:your_package/extensions/rate_limit.dart';
import 'package:your_package/core/ds_shelf_core.dart';

Future<void> main() async {
  // 1️⃣ Load your app config (e.g. ALLOWED_ORIGINS, API_KEYs)
  final config = AppConfig.load();

  // 2️⃣ Initialize the core server
  final server = DSShelfCore();

  // 3️⃣ Add middleware in the recommended order:
  server.addMiddleware(shelf.logRequests());                          // Logging
  server.addMiddleware(cors(originChecker: config.originChecker));   // CORS
  server.addMiddleware(
    apiKeyAuth(
      headerName: 'x-api-key',
      validate: (key) => key == config.expectedApiKey,
    ),
  );                                                                 // API-Key auth
  server.addMiddleware(rateLimit(perMinute: 60));                    // Rate limiting

  // 4️⃣ Register application routes
  server.addGetRoute('/health', (req) => shelf.Response.ok('OK'));
  server.addGetRoute('/users/<id>', (req, String id) {
    // … your handler …
  });

  // 5️⃣ Start listening
  final handler = server.handler;
  final port    = int.parse(Platform.environment['PORT'] ?? '8080');
  await shelf.serve(handler, InternetAddress.anyIPv4, port);
  print('🚀 Listening on port $port');
}
```

### Configuration Options

* **CORS**

  ```dart
  /// Only allow requests from these origins:
  final origins = ['https://foo.com', 'https://bar.com'];
  final checker = dsOriginOneOf(origins);
  server.addMiddleware(cors(originChecker: checker));
  ```
* **API-Key Auth**

  ```dart
  server.addMiddleware(apiKeyAuth(
    headerName: 'x-api-key',         // header to read
    validate: (key) => key == '…',   // your custom validator
    onUnauthorized: (req) => shelf.Response.forbidden('Invalid key'),
  ));
  ```
* **Rate Limiting**

  ```dart
  // max 100 requests per minute per client IP
  server.addMiddleware(rateLimit(perMinute: 100));
  ```

### Best Practices

1. **Order matters**

   * Log first, so you capture all traffic.
   * Apply CORS before any auth checks.
   * Auth early, to reject unauthorized requests ASAP.
   * Rate limits after auth, so you can give stricter caps to anonymous clients.

2. **Grouping & Reuse**

   * Factor common pipelines into a helper:

     ```dart
     Pipeline defaultPipeline(AppConfig config) {
       return Pipeline()
         .addMiddleware(logRequests())
         .addMiddleware(cors(originChecker: config.originChecker))
         .addMiddleware(apiKeyAuth(...))
         .addMiddleware(rateLimit(perMinute: 60));
     }
     ```

3. **Error Handling**

   * Provide clear `onUnauthorized` and `onLimitExceeded` handlers to return JSON or custom error pages.
   * Wrap downstream handler in a `try/catch` middleware if you need centralized error logging.

With these building blocks, you can mix-and-match Shelf middleware to secure, monitor, and scale your DartStream-powered server.

---

## Package Conflicts and Aliases

In some cases, core dart package have naming conflicts (ie. same method, classname).  For some packages, we build wrappers and use the DS prefix to avoid those conflicts.  

In other cases, where may avoid using a package altogether.  We will keep the documentation up to date as often as possible.

## Licensing

All Dartstream packages are licensed under BSD-3, except for the *services packages*, which uses the ELv2 license, and the *Dartstream SDK packages*, which are licensed from third party software Aortem Inc. In short, this means that you can, without limitation, use any of the client packages in your app as long as you do not offer the SDK's or services as a cloud service to 3rd parties (this is typically only relevant for cloud service providers).  See the [LICENSE](LICENSE.md) file for more details.


## Enhance with DartStream

We hope DartStream helps you to efficiently build and scale your server-side applications. Join our growing community and start contributing to the ecosystem today!