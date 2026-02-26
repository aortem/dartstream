import 'package:ds_shelf/core/ds_shelf_core.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

void main() {
  group('DSShelfCore nested routing', () {
    test('addGetRoute supports colon dynamic params', () async {
      final core = DSShelfCore();
      core.addGetRoute('/product/:id', (request) {
        return Response.ok('id=${request.params['id']}');
      });

      final response = await core.handler(
        Request('GET', Uri.parse('http://localhost/product/abc-123')),
      );
      expect(response.statusCode, 200);
      expect(await response.readAsString(), 'id=abc-123');
    });

    test('addPostRoute supports colon dynamic params', () async {
      final core = DSShelfCore();
      core.addPostRoute('/orders/:orderId/items/:itemId', (request) {
        final orderId = request.params['orderId'];
        final itemId = request.params['itemId'];
        return Response.ok('order=$orderId,item=$itemId');
      });

      final postResponse = await core.handler(
        Request('POST', Uri.parse('http://localhost/orders/42/items/7')),
      );
      expect(postResponse.statusCode, 200);
      expect(await postResponse.readAsString(), 'order=42,item=7');

      final wrongMethod = await core.handler(
        Request('GET', Uri.parse('http://localhost/orders/42/items/7')),
      );
      expect(wrongMethod.statusCode, 404);
    });

    test('mountRouter supports nested child router paths', () async {
      final core = DSShelfCore();
      final usersRouter = Router()
        ..get('/', (_) => Response.ok('users-index'))
        ..get('/<id>', (_, String id) => Response.ok('user-$id'));

      core.mountRouter('/users', usersRouter);

      final usersRoot = await core.handler(
        Request('GET', Uri.parse('http://localhost/users')),
      );
      expect(usersRoot.statusCode, 301);
      expect(usersRoot.headers['location'], 'http://localhost/users/');

      final usersTrailingSlash = await core.handler(
        Request('GET', Uri.parse('http://localhost/users/')),
      );
      expect(usersTrailingSlash.statusCode, 200);
      expect(await usersTrailingSlash.readAsString(), 'users-index');

      final userById = await core.handler(
        Request('GET', Uri.parse('http://localhost/users/42')),
      );
      expect(userById.statusCode, 200);
      expect(await userById.readAsString(), 'user-42');
    });

    test('mount normalizes non-root mount paths', () async {
      final core = DSShelfCore();
      final adminRouter = Router()..get('/metrics', (_) => Response.ok('ok'));

      core.mount('/admin', adminRouter.call);

      final response = await core.handler(
        Request('GET', Uri.parse('http://localhost/admin/metrics')),
      );
      expect(response.statusCode, 200);
      expect(await response.readAsString(), 'ok');
    });
  });
}
