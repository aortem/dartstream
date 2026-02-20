import 'package:ds_middleware/ds_custom_middleware.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

// Sample custom class for testing
class User {
  final String name;
  final int age;

  User(this.name, this.age);

  Map<String, dynamic> toJson() => {'name': name, 'age': age};

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['name'], json['age']);
  }
}

// Handler for User
class UserHandler implements TypeHandler<User> {
  @override
  dynamic serialize(User value) {
    return value.toJson();
  }

  @override
  User deserialize(dynamic value) {
    if (value is Map<String, dynamic>) {
      return User.fromJson(value);
    }
    throw FormatException('Expected Map for User deserialization');
  }

  @override
  bool canHandle(dynamic value) => value is User;
}

void main() {
  group('Type Handler Tests', () {
    test('DateHandler Serialization', () {
      final handler = DateHandler();
      final date = DateTime.utc(2023, 10, 27, 12, 0, 0);
      expect(handler.serialize(date), equals('2023-10-27T12:00:00.000Z'));
    });

    test('DateHandler Deserialization', () {
      final handler = DateHandler();
      final date = handler.deserialize('2023-10-27T12:00:00.000Z');
      expect(date.isUtc, isTrue);
      expect(date.year, equals(2023));
    });

    test('TypeHandlerRegistry Registration', () {
      TypeHandlerRegistry.register<User>(UserHandler());
      expect(TypeHandlerRegistry.hasHandler<User>(), isTrue);
    });

    test('Request bodyAs<T>', () {
      TypeHandlerRegistry.register<User>(UserHandler());

      final userMap = {'name': 'Alice', 'age': 30};
      final request = DsCustomMiddleWareRequest(
        'POST',
        Uri.parse('/users'),
        {},
        userMap, // Body is Map
        {},
      );

      final user = request.bodyAs<User>();
      expect(user.name, equals('Alice'));
      expect(user.age, equals(30));
    });

    test('Response Automatic Serialization', () {
      TypeHandlerRegistry.register<User>(UserHandler());

      final user = User('Bob', 25);
      final response = DsCustomMiddleWareResponse.ok(user);

      // The body should be automatically serialized to Map
      expect(response.body, isA<Map<String, dynamic>>());
      expect(response.body['name'], equals('Bob'));
    });

    test('Response with unknown type returns raw value', () {
      final response = DsCustomMiddleWareResponse.ok(12345);
      expect(response.body, equals(12345));
    });
  });
}
