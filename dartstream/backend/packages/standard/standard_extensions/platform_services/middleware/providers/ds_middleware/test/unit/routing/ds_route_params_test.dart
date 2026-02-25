import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:ds_middleware/routing/ds_route_params.dart';

void main() {
  late DsRouteParamHandler handler;

  setUp(() {
    handler = DsRouteParamHandler();
  });

  group('Basic Param Extraction', () {
    test('extracts simple param', () {
      final params =
          handler.extractParams('/user/:id', '/user/123');

      expect(params['id'], '123');
    });
  });

  group('Optional Parameters', () {
    test('optional param present', () {
      final params =
          handler.extractParams('/user/:id?', '/user/42');

      expect(params['id'], '42');
    });

    test('optional param missing', () {
      final params =
          handler.extractParams('/user/:id?', '/user');

      expect(params['id'], isNull);
    });
  });

  group('Typed Parameters', () {
    test('int type success', () {
      final params =
          handler.extractParams('/user/:id(int)', '/user/99');

      expect(params['id'], 99);
      expect(params['id'], isA<int>());
    });

    test('double type success', () {
      final params =
          handler.extractParams('/price/:amount(double)', '/price/19.99');

      expect(params['amount'], 19.99);
      expect(params['amount'], isA<double>());
    });

    test('bool type success', () {
      final params =
          handler.extractParams('/flag/:active(bool)', '/flag/true');

      expect(params['active'], true);
    });

    test('invalid int throws', () {
      expect(
        () => handler.extractParams('/user/:id(int)', '/user/abc'),
        throwsException,
      );
    });
  });

  group('Wildcard Parameters', () {
    test('captures remaining path', () {
      final params =
          handler.extractParams('/files/*', '/files/docs/2024/report.pdf');

      expect(params['wildcard'], 'docs/2024/report.pdf');
    });

    test('wildcard with no extra path', () {
      final params =
          handler.extractParams('/files/*', '/files');

      expect(params['wildcard'], '');
    });
  });

  group('Missing Required Param', () {
    test('throws when required param missing', () {
      expect(
        () => handler.extractParams('/user/:id', '/user'),
        throwsException,
      );
    });
  });
}