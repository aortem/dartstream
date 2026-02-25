import '../query_string/ds_query_string_handler.dart';
import '../../app/models/ds_custom_middleware_model.dart';
import 'package:shelf/shelf.dart';

class ProductRoutes {
  final DsQueryStringHandler queryHandler = DsQueryStringHandler();

  /// Handle GET /products
  Response handleProducts(DsCustomMiddleWareRequest request) {
    // Attach query parameters to request
    final updatedRequest = queryHandler.attachToRequest(request);

    // Extract query parameters safely
    final category = queryHandler.getString(updatedRequest, 'category', defaultValue: 'all');
    final minPrice = queryHandler.getDouble(updatedRequest, 'minPrice', defaultValue: 0);
    final maxPrice = queryHandler.getDouble(updatedRequest, 'maxPrice', defaultValue: 10000);
    final limit = queryHandler.getInt(updatedRequest, 'limit', defaultValue: 10);
    final featured = queryHandler.getBool(updatedRequest, 'featured', defaultValue: false);

    // Example response (replace with actual product filtering logic)
    final result = {
      'category': category,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'limit': limit,
      'featured': featured
    };

    return Response.ok(result.toString(), headers: {'Content-Type': 'application/json'});
  }
}