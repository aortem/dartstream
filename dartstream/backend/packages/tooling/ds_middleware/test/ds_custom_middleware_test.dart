// // // // // // import 'dart:developer';

// // // // // // import 'package:ds_custom_middleware/ds_custom_middleware.dart';
// // // // // // import 'package:test/test.dart';
// // // // // // import 'package:http/http.dart' ;

// // // // // // // import '../lib/ds_custom_middleware.dart';
// // // // // // // import 'package:ds_standard_features/ds_standard_features.dart';
// // // // // // // import 'package:ds_standard_features/ds_standard_features.dart' as ds_features;

// // // // // // void main() {
// // // // // //   group('Middleware Tests', () {
// // // // // //     test('Test middleware chain execution', () async {
// // // // // //       // Define your _runMiddlewareChain function here
// // // // // //       Future<Response> _runMiddlewareChain(Request request, Handler handler,
// // // // // //           List<Middleware> middlewares) async {
// // // // // //         Handler currentHandler = handler;

// // // // // //         // Chain middlewares in reverse order
// // // // // //         for (final middleware in middlewares.reversed) {
// // // // // //           currentHandler = (Request request) async {
// // // // // //             return await middleware(request, currentHandler);
// // // // // //           };
// // // // // //         }

// // // // // //         // Start request handling
// // // // // //         return await currentHandler(request);
// // // // // //       }

// // // // // //       // Your test logic goes here
// // // // // //       // Define a mock request
// // // // // //       final request = Request('test', Uri.parse('https://example.com'));

// // // // // //       // Define a handler function for the request
// // // // // //       Handler handler = (Request request) async {
// // // // // //         return Response('{"message": "Handled request"}', 200);
// // // // // //       };

// // // // // //       // Initialize your middleware
// // // // // //       final dsCustomMiddleware1 =
// // // // // //           DsCustomMiddleware((Request request, Handler handler) async {
// // // // // //         // Middleware logic goes here
// // // // // //         print('Executing middleware 1');
// // // // // //         return await handler(request);
// // // // // //       });

// // // // // //       final dsCustomMiddleware2 =
// // // // // //           DsCustomMiddleware((Request request, Handler handler) async {
// // // // // //         // Another middleware logic goes here
// // // // // //         print('Executing middleware 2');
// // // // // //         return await handler(request);
// // // // // //       });

// // // // // //       // Create middleware chain
// // // // // //       final middlewareChain = <Middleware>[
// // // // // //         (Request request, Handler handler) async {
// // // // // //           return await dsCustomMiddleware1.call(request, handler);
// // // // // //         },
// // // // // //         (Request request, Handler handler) async {
// // // // // //           return await dsCustomMiddleware2.call(request, handler);
// // // // // //         },
// // // // // //       ];

// // // // // //       // Pass request through middleware chain
// // // // // //       final response =
// // // // // //           await _runMiddlewareChain(request, handler, middlewareChain);

// // // // // // log("response is $response");

// // // // // //       // Verify response
// // // // // //       // expect(response.statusCode,
// // // // // //       //     ds_features.equals('200', '')); // Compare with an integer value
// // // // // //       // expect(
// // // // // //       //     response.body,
// // // // // //       //     ds_features.equals('{"message": "Handled request"}',
// // // // // //       //         '')); // Compare with a string value
// // // // // //     });
// // // // // //   });
// // // // // // }
// // // // // import 'package:ds_custom_middleware/ds_custom_middleware.dart';
// // // // // import 'package:http/http.dart';
// // // // // import 'package:test/test.dart';

// // // // // void main() {
// // // // //   test('Middleware chain runs correctly', () async {
// // // // //     final middlewareChain = <Middleware>[
// // // // //       (Request request, Handler handler) async {
// // // // //         // First middleware logic
// // // // //         print('First middleware');
// // // // //         final response = await handler(request);
// // // // //         // Additional logic if needed
// // // // //         return response;
// // // // //       },
// // // // //       (Request request, Handler handler) async {
// // // // //         // Second middleware logic
// // // // //         print('Second middleware');
// // // // //         final response = await handler(request);
// // // // //         // Additional logic if needed
// // // // //         return response;
// // // // //       },
// // // // //     ];

// // // // //     final response = await _runMiddlewareChain(
// // // // //         Request('GET', Uri.parse("https://example.com")),
// // // // //         myRequestHandler,
// // // // //         middlewareChain);

// // // // //     expect(response.statusCode, equals(200)); // Assuming myRequestHandler returns 200
// // // // //   });
// // // // // }
// // // // import 'package:ds_custom_middleware/ds_custom_middleware.dart';
// // // // import 'package:http/http.dart';
// // // // import 'package:test/test.dart';

// // // // void main() {
// // // //   test('Middleware chain runs correctly', () async {
// // // //     final middlewareChain = <Middleware>[
// // // //       (Request request, Handler handler) async {
// // // //         // First middleware logic
// // // //         print('First middleware');
// // // //         final response = await handler(request);
// // // //         // Additional logic if needed
// // // //         return response;
// // // //       },
// // // //       (Request request, Handler handler) async {
// // // //         // Second middleware logic
// // // //         print('Second middleware');
// // // //         final response = await handler(request);
// // // //         // Additional logic if needed
// // // //         return response;
// // // //       },
// // // //     ];

// // // //     final response = await _runMiddlewareChain(
// // // //         Request('GET', Uri.parse("https://example.com")),
// // // //         myRequestHandler,
// // // //         middlewareChain);

// // // //     expect(response.statusCode, equals(200)); // Assuming myRequestHandler returns 200
// // // //   });
// // // // }
// // // import 'package:ds_custom_middleware/ds_custom_middleware.dart';
// // // import 'package:http/http.dart';
// // // import 'package:test/test.dart';

// // // void main() {
// // //   test('Middleware chain runs correctly', () async {
// // //     final middlewareChain = <Middleware>[
// // //       (Request request, Handler handler) async {
// // //         // First middleware logic
// // //         print('First middleware');
// // //         final response = await handler(request);
// // //         // Additional logic if needed
// // //         return response;
// // //       },
// // //       (Request request, Handler handler) async {
// // //         // Second middleware logic
// // //         print('Second middleware');
// // //         final response = await handler(request);
// // //         // Additional logic if needed
// // //         return response;
// // //       },
// // //     ];

// // //     final response = await _runMiddlewareChain(
// // //         Request('GET', Uri.parse("https://example.com")),
// // //         myRequestHandler,
// // //         middlewareChain);

// // //     expect(response.statusCode, equals(200)); // Assuming myRequestHandler returns 200
// // //   });
// // // }
// // import 'package:test/test.dart';
// // import 'package:ds_custom_middleware/ds_custom_middleware.dart';import 'package:http/http.dart';
// // void main() {
// //   test('Middleware chain runs correctly', () async {
// //     final middlewareChain = <Middleware>[
// //       (Request request, Handler handler) async {
// //         // First middleware logic
// //         print('First middleware');
// //         final response = await handler(request);
// //         // Additional logic if needed
// //         return response;
// //       },
// //       (Request request, Handler handler) async {
// //         // Second middleware logic
// //         print('Second middleware');
// //         final response = await handler(request);
// //         // Additional logic if needed
// //         return response;
// //       },
// //     ];

// //     final response = await _runMiddlewareChain(
// //         Request('GET', Uri.parse("https://example.com")),
// //         myRequestHandler,
// //         middlewareChain);

// //     expect(response.statusCode, equals(200)); // Assuming myRequestHandler returns 200
// //   });
// // }

// // Future<void> main(List<String> args) async {
// //   final dsCustomMiddleware1 =
// //       DsCustomMiddleware((Request request, Handler handler) async {
// //     // Middleware logic goes here
// //     return await handler(request);
// //   });

// //   final dsCustomMiddleware2 =
// //       DsCustomMiddleware((Request request, Handler handler) async {
// //     // Another middleware logic goes here
// //     return await handler(request);
// //   });

// //   final middlewareChain = <Middleware>[
// //     (Request request, Handler handler) async {
// //       return await dsCustomMiddleware1.call(request, handler);
// //     },
// //     (Request request, Handler handler) async {
// //       return await dsCustomMiddleware2.call(request, handler);
// //     },
// //   ];

// //   final response = await _runMiddlewareChain(
// //       Request('GET', Uri.parse("https://example.com")),
// //       myRequestHandler,
// //       middlewareChain);

// //   // Handle response
// //   print(response.statusCode); // Example handling
// // }

// import 'package:ds_custom_middleware/ds_custom_middleware.dart';

// import 'package:http/http.dart';
// import 'package:test/test.dart';

// void main() {
//   test('Middleware chain runs correctly', () async {
//     final middlewareChain = <Middleware>[
//       (Request request, Handler handler) async {
//         // First middleware logic
//         print('First middleware');
//         final response = await handler(request);
//         // Additional logic if needed
//         return response;
//       },
//       (Request request, Handler handler) async {
//         // Second middleware logic
//         print('Second middleware');
//         final response = await handler(request);
//         // Additional logic if needed
//         return response;
//       },
//     ];

//     final response = await runMiddlewareChain(
//         Request('GET', Uri.parse("https://example.com")),
//         myRequestHandler,
//         middlewareChain);

//     expect(response.statusCode, equals(200)); // Assuming myRequestHandler returns 200
//   });
// }
import 'package:ds_custom_middleware/ds_custom_middleware.dart';
import 'package:ds_standard_features/ds_standard_features.dart'; //as dsmahca;
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  test('Middleware chain runs correctly', () async {
    final middlewareChain = <Middleware>[
      (Request request, Handler handler) async {
        // First middleware logic
        print('First middleware');
        print('request $request');
        print('handler $handler');
        final response = await handler(request);
        // Additional logic if needed
        return response;
      },
      (Request request, Handler handler) async {
        // Second middleware logic
        print('Second middleware');
        final response = await handler(request);
        // Additional logic if needed
        return response;
      },
    ];
    final response1 = await myRequestHandler(
        Request('GET', Uri.parse("https://example.com")));
    print(response1.body); // Print the response body
    expect(response1.statusCode, equals(200));
    final response = await runMiddlewareChain(
        Request('GET', Uri.parse("https://example.com")),
        myRequestHandler,
        middlewareChain);

    expect(response.statusCode,
        equals(200)); // Assuming myRequestHandler returns 200
  });
}
