import 'package:ds_custom_middleware/ds_custom_middleware.dart';

Future<String> testCors() async {
  final corsMiddleware = DsCorsMiddleware(
    allowedOrigins: ['https://example.com'],
    allowCredentials: true,
  );

  final request = DsCustomMiddleWareRequest(
    'GET',
    Uri.parse('/test'),
    {'Origin': 'https://example.com'},
    null,
  );

  final response = await corsMiddleware.handle(request, (req) async {
    return DsCustomMiddleWareResponse.ok('Test response');
  });

  return 'CORS test completed. Headers: ${response.headers}';
}
