//import 'package:ds_custom_middleware/ds_custom_middleware.dart';
//import 'package:ds_standard_features/ds_standard_features.dart'
//  as ds_standard_features;

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart' as ds_match;

import 'app/middleware/ds_custom_core_middleware.dart'; //as dsmahca;

void main() {
  ds_match.test('Middleware chain runs correctly', () async {
    final middlewareChain = <Middleware>[
      (http.Request request, Handler handler) async {
        // First middleware logic
        print('First middleware');
        print('request $request');
        print('handler $handler');
        final response = await handler(request);
        // Additional logic if needed
        return response;
      },
      (http.Request request, Handler handler) async {
        // Second middleware logic
        print('Second middleware');
        final response = await handler(request);
        // Additional logic if needed
        return response;
      },
    ];
    final response1 = await myRequestHandler(
        http.Request('GET', Uri.parse("https://example.com")));
    print(response1.body); // Print the response body
    ds_match.expect(response1.statusCode, ds_match.equals(200));
    final response = await runMiddlewareChain(
        http.Request('GET', Uri.parse("https://example.com")),
        myRequestHandler,
        middlewareChain);

    ds_match.expect(response.statusCode,
        ds_match.equals(200)); // Assuming myRequestHandler returns 200
  });
}
