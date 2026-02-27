import 'package:ds_shelf/core/ds_shelf_core.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

void main() {
  group('DSShelfCore nested routing', () {
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
