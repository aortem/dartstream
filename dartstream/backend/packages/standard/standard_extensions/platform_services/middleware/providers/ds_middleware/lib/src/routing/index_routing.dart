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


class IndexRouter {
  Future<DsCustomMiddleWareResponse> handleIndexRequest(DsCustomMiddleWareRequest request) async {
    if (request.uri.path == '/' || request.uri.path == '/index') {
      return DsCustomMiddleWareResponse.ok('Welcome to the homepage!');
    } else {
      return DsCustomMiddleWareResponse.notFound();
    }
  }
}
