import 'package:ds_custom_middleware/ds_custom_middleware.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

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
