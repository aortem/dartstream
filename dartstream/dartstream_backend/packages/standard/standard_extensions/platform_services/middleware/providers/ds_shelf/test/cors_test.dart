//import 'package:ds_shelf/ds_shelf.dart';
import 'package:test/test.dart';
import '../lib/ds_shelf.dart';
import '../lib/extensions/cors/ds_shelf_cors_middleware.dart';

void main() {
  test('CORS middleware is exported', () {
    final mw = dsShelfCorsMiddleware();
    expect(mw, isNotNull);
  });
}
