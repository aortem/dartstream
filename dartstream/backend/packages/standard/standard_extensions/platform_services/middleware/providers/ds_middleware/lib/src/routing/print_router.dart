import '../../app/models/ds_custom_middleware_model.dart';

class PrintRouter {
  Future<DsCustomMiddleWareResponse> handlePrintRequest(DsCustomMiddleWareRequest request) async {
    final responseString = 'Request received: ${request.method} ${request.uri.path}\nHeaders:\n${request.headers}';
    print(responseString);
    return DsCustomMiddleWareResponse.ok('Request details have been printed to the console.');
  }
}
