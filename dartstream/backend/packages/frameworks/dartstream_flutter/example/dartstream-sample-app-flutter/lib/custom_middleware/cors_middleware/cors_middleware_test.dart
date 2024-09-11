import 'package:ds_custom_middleware/app/middleware/ds_cors_middleware.dart';
import 'package:ds_custom_middleware/ds_custom_middleware.dart';

Future<String> testCorsMiddleware() async {
  final corsMiddleware = DsCorsMiddleware();
  final request = DsCustomMiddleWareRequest(
    'OPTIONS',
    Uri.parse('http://localhost:8080/api'),
    {'origin': 'http://example.com'},
    null,
    {},
  );
  final response = await corsMiddleware.handle(
      request, (_) async => throw UnimplementedError());
  return 'CORS headers added: ${response.headers['Access-Control-Allow-Origin']}';
}
