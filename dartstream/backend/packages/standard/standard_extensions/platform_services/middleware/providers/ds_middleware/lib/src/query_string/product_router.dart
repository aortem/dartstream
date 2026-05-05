import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import '../routing/product_routes.dart';
import '../../app/models/ds_custom_middleware_model.dart';

Router getProductRouter() {
  final router = Router();
  final productRoutes = ProductRoutes();

  router.get('/products', (Request request) {
    try {
      final customRequest = DsCustomMiddleWareRequest.fromShelf(request);
      return productRoutes.handleProducts(customRequest);
    } catch (e, st) {
      print('Error in /products: $e\n$st');
      return Response.internalServerError(body: 'Internal Server Error: $e');
    }
  });

  return router;
}
