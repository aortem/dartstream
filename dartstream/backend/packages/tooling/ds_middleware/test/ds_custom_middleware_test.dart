import 'package:test/test.dart';
import '../lib/ds_custom_middleware.dart';
import 'package:ds_standard_features/ds_standard_features.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as ds_features;

void main() {
  group('Middleware Tests', () {
    test('Test middleware chain execution', () async {
      // Define your _runMiddlewareChain function here
      Future<Response> _runMiddlewareChain(Request request, Handler handler,
          List<Middleware> middlewares) async {
        Handler currentHandler = handler;

        // Chain middlewares in reverse order
        for (final middleware in middlewares.reversed) {
          currentHandler = (Request request) async {
            return await middleware(request, currentHandler);
          };
        }

        // Start request handling
        return await currentHandler(request);
      }

      // Your test logic goes here
      // Define a mock request
      final request = Request('test', Uri.parse('https://example.com'));

      // Define a handler function for the request
      Handler handler = (Request request) async {
        return Response('{"message": "Handled request"}', 200);
      };

      // Initialize your middleware
      final dsCustomMiddleware1 =
          DsCustomMiddleware((Request request, Handler handler) async {
        // Middleware logic goes here
        print('Executing middleware 1');
        return await handler(request);
      });

      final dsCustomMiddleware2 =
          DsCustomMiddleware((Request request, Handler handler) async {
        // Another middleware logic goes here
        print('Executing middleware 2');
        return await handler(request);
      });

      // Create middleware chain
      final middlewareChain = <Middleware>[
        (Request request, Handler handler) async {
          return await dsCustomMiddleware1.call(request, handler);
        },
        (Request request, Handler handler) async {
          return await dsCustomMiddleware2.call(request, handler);
        },
      ];

      // Pass request through middleware chain
      final response =
          await _runMiddlewareChain(request, handler, middlewareChain);

      // Verify response
      expect(response.statusCode,
          ds_features.equals('200', '')); // Compare with an integer value
      expect(
          response.body,
          ds_features.equals('{"message": "Handled request"}',
              '')); // Compare with a string value
    });
  });
}
