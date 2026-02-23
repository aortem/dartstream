import 'package:ds_shelf/core/ds_shelf_core.dart';
import 'package:shelf/shelf.dart';

void main() {
  print('🧪 Testing Print Routes Feature...');
  
  final server = DSShelfCore();
  
  // Register some test routes
  server.addGetRoute('/api/users', (Request request) => Response.ok('Users'));
  server.addGetRoute('/api/posts', (Request request) => Response.ok('Posts'));
  
  // Print the routes
  print('\nCalling printRoutes():\n');
  server.printRoutes();
  
  print('\n✅ Test Complete');
}
