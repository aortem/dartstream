import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import '../../routing/ds_query_string_handler.dart'; // the utility handler
import '../routing/product_routes.dart';
import '../../app/models/ds_custom_middleware_model.dart';

Router getProductRouter() {
  final router = Router();
  final productRoutes = ProductRoutes();

  router.get('/products', (Request request) {
    try {
      final customRequest = DsCustomMiddleWareRequest.fromShelf(request);
      if (customRequest == null) {
        return Response.badRequest(body: 'Invalid request format');
      }
      return productRoutes.handleProducts(customRequest as DsCustomMiddleWareRequest);
    } catch (e, st) {
      print('Error in /products: $e\n$st');
      return Response.internalServerError(body: 'Internal Server Error: $e');
    }
  });

  return router;
}