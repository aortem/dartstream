import 'package:test/test.dart';
import 'package:ds_dartstream/backend/packages/tooling/cli_util/lib/core/ds_make.dart';

void main() {
  group('DSCore', () {
    test('core functionality behaves as expected', () {
      var make = DSMake();

      // Assuming DSCore has a method `performAction` you want to test
      var result = make.performAction();

      // Verify the result is as expected
      expect(result, equals("Expected Result"));
    });
  });
}
