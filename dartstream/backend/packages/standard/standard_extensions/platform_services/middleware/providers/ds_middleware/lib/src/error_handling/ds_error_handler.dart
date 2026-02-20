<<<<<<< HEAD
import 'package:ds_middleware/app/models/ds_custom_middleware_model.dart';
import 'package:ds_middleware/app/models/ds_custom_middleware_model.dart';
=======
<<<<<<< HEAD
import 'package:ds_middleware/app/models/ds_custom_middleware_model.dart';
import 'package:ds_middleware/app/models/ds_custom_middleware_model.dart';
=======
import '../../app/models/ds_custom_middleware_model.dart';

>>>>>>> development
>>>>>>> development

class DsErrorHandler {
  Future<DsCustomMiddleWareResponse> handle(
    DsCustomMiddleWareRequest request,
    Future<DsCustomMiddleWareResponse> Function(DsCustomMiddleWareRequest) next,
  ) async {
    try {
      return await next(request);
    } catch (e) {
      print('Error caught: $e');
      return DsCustomMiddleWareResponse(
        500,
        {'Content-Type': 'application/json'},
        '{"error": "Internal Server Error"}',
      );
    }
  }

  DsCustomMiddleWareResponse handleNotFound() {
    return DsCustomMiddleWareResponse(
      404,
      {'Content-Type': 'application/json'},
      '{"error": "Not Found"}',
    );
  }

  DsCustomMiddleWareResponse handleBadRequest(String message) {
    return DsCustomMiddleWareResponse(
      400,
      {'Content-Type': 'application/json'},
      '{"error": "Bad Request", "message": "$message"}',
    );
  }
}
