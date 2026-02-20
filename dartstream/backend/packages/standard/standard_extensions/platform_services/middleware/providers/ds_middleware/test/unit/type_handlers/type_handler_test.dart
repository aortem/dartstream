import 'package:ds_middleware/src/type_handlers/type_handler.dart';
import 'package:ds_middleware/src/type_handlers/type_handler_registry.dart';
import 'package:ds_middleware/src/type_handlers/date_handler.dart';
// import 'package:ds_middleware/ds_custom_middleware.dart'; // Can't import this if it's not exported nicely?
// Importing implementation details for testing
import 'package:ds_middleware/app/models/ds_custom_middleware_model.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

class CustomClass {
  final String value;
  CustomClass(this.value);
  Map<String, dynamic> toJson() => {'value': value};
  static CustomClass fromJson(Map<String, dynamic> json) => CustomClass(json['value']);
}

class CustomClassHandler implements TypeHandler<CustomClass> {
  @override
  bool canHandle(dynamic value) => value is CustomClass;

  @override
  CustomClass deserialize(dynamic value) {
    if (value is Map<String, dynamic>) {
      return CustomClass.fromJson(value);
    }
    throw FormatException('Invalid input for CustomClass');
  }

  @override
  dynamic serialize(CustomClass value) {
    return value.toJson();
  }
}

void main() {
  group('TypeHandlerRegistry Tests', () {
    setUp(() {
      // Clear handlers might not be possible if static? 
      // Actually TypeHandlerRegistry._handlers is static final Map.
      // We can just overwrite or add new ones.
    });

    test('Registers and retrieves handlers', () {
      TypeHandlerRegistry.register<CustomClass>(CustomClassHandler());
      // We cannot easily check private _handlers but we can check behavior
      final obj = CustomClass('hello');
      final serialized = TypeHandlerRegistry.serialize(obj);
      expect(serialized, equals({'value': 'hello'}));
    });

    test('DateHandler serialization', () {
      final handler = DateHandler();
      final date = DateTime.utc(2023, 1, 1, 12, 0, 0);
      final serialized = handler.serialize(date);
      expect(serialized, equals('2023-01-01T12:00:00.000Z'));
    });

    test('DateHandler deserialization', () {
      final handler = DateHandler();
      final dateStr = '2023-01-01T12:00:00.000Z';
      final deserialized = handler.deserialize(dateStr);
      expect(deserialized, equals(DateTime.utc(2023, 1, 1, 12, 0, 0)));
    });

    test('DsCustomMiddleWareRequest bodyAs<T>', () {
      TypeHandlerRegistry.register<CustomClass>(CustomClassHandler());
      final request = DsCustomMiddleWareRequest(
        'POST',
        Uri.parse('/'),
        {},
        {'value': 'test'},
        {},
      );
      
      final result = request.bodyAs<CustomClass>();
      expect(result, isA<CustomClass>());
      expect(result.value, equals('test'));
    });

    test('DsCustomMiddleWareResponse auto-serialization', () {
       TypeHandlerRegistry.register<CustomClass>(CustomClassHandler());
       final obj = CustomClass('response');
       final response = DsCustomMiddleWareResponse.ok(obj);
       // The factory might trigger serialization if implemented in DsCustomMiddleWareResponse.ok
       // Check implementation plan: "Modify DsCustomMiddleWareResponse ... to automatically serialize"
       // Let's verify if that was actually implemented in the code.
       // Assuming it was:
       expect(response.body, equals({'value': 'response'}));
    });
  });
}
