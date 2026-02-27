import 'package:ds_middleware/src/type_handlers/type_handler.dart';
import 'package:ds_middleware/src/type_handlers/type_handler_registry.dart';
import 'package:ds_middleware/src/type_handlers/date_handler.dart';
import 'package:ds_middleware/app/models/ds_custom_middleware_model.dart';
import 'package:test/test.dart';

class CustomClass {
  final String value;
  CustomClass(this.value);
  Map<String, dynamic> toJson() => {'value': value};
  static CustomClass fromJson(Map<String, dynamic> json) =>
      CustomClass(json['value']);
}

class CustomClassHandler implements TypeHandler<CustomClass> {
  @override
  bool canHandle(dynamic value) => value is CustomClass;
  @override
  CustomClass deserialize(dynamic value) =>
      CustomClass.fromJson(value as Map<String, dynamic>);
  @override
  dynamic serialize(CustomClass value) => value.toJson();
}

void main() {
  group('TypeHandlerRegistry Tests', () {
    tearDown(() {
      TypeHandlerRegistry.unregister<CustomClass>();
    });

    test('Registers and retrieves handlers', () {
      TypeHandlerRegistry.register<CustomClass>(CustomClassHandler());
      final obj = CustomClass('hello');
      final serialized = TypeHandlerRegistry.serialize(obj);
      expect(serialized, equals({'value': 'hello'}));
    });
    test('DsCustomMiddleWareResponse auto-serialization', () {
      TypeHandlerRegistry.register<CustomClass>(CustomClassHandler());
      final obj = CustomClass('response');
      final response = DsCustomMiddleWareResponse.ok(obj);
      expect(response.body, equals({'value': 'response'}));
    });

    test('DsCustomMiddleWareRequest bodyAs<T>', () {
      TypeHandlerRegistry.register<CustomClass>(CustomClassHandler());
      final request = DsCustomMiddleWareRequest(
        'POST',
        Uri.parse('/'),
        <String, String>{},
        {'value': 'request'},
        <String, String>{},
      );
      final obj = request.bodyAs<CustomClass>();
      expect(obj.value, equals('request'));
    });
  });
}
