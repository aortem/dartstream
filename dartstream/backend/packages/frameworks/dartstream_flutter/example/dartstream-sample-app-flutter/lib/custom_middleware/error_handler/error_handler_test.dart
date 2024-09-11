import 'package:ds_custom_middleware/app/error_handling/ds_error_handler.dart';
import 'package:ds_custom_middleware/ds_custom_middleware.dart';

Future<String> testErrorHandler() async {
  final errorHandler = DsErrorHandler();
  final request = DsCustomMiddleWareRequest(
    'GET',
    Uri.parse('http://localhost:8080/not-found'),
    {},
    null,
    {},
  );
  final response = await errorHandler.handle(
      request, (_) => throw NotFoundException('Resource not found'));
  return 'Error handled: ${response.statusCode}';
}
