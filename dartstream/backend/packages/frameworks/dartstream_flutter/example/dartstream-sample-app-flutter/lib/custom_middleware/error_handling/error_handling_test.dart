import 'package:ds_custom_middleware/ds_custom_middleware.dart';

Future<String> testErrorHandling() async {
  final errorHandler = DsErrorHandler();

  final request =
      DsCustomMiddleWareRequest('GET', Uri.parse('/test'), {}, null);

  final normalResponse = await errorHandler.handle(request, (req) async {
    return DsCustomMiddleWareResponse.ok('Normal response');
  });

  final errorResponse = await errorHandler.handle(request, (req) async {
    throw Exception('Test error');
  });

  final notFoundResponse = errorHandler.handleNotFound();

  final badRequestResponse = errorHandler.handleBadRequest('Invalid input');

  return 'Normal Response: ${normalResponse.statusCode}\n'
      'Error Response: ${errorResponse.statusCode}\n'
      'Not Found Response: ${notFoundResponse.statusCode}\n'
      'Bad Request Response: ${badRequestResponse.statusCode}';
}
