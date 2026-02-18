import 'dart:convert';
import 'package:ds_middleware/ds_custom_middleware.dart';

// Sample User class
class User {
  final String name;
  final int age;

  User(this.name, this.age);

  Map<String, dynamic> toJson() => {'name': name, 'age': age};

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['name'], json['age']);
  }

  @override
  String toString() => 'User(name: $name, age: $age)';
}

// User Handler
class UserHandler implements TypeHandler<User> {
  @override
  dynamic serialize(User value) => value.toJson();

  @override
  User deserialize(dynamic value) {
    if (value is Map<String, dynamic>) {
      return User.fromJson(value);
    }
    // Handle stringified JSON if needed
    if (value is String) {
       return User.fromJson(jsonDecode(value));
    }
    throw FormatException('Cannot deserialize User from $value');
  }

  @override
  bool canHandle(dynamic value) => value is User;
}

void main() async {
  print('--- Custom Type Handler Example ---\n');

  // 1. Register Handlers
  print('1. Registering Handlers...');
  TypeHandlerRegistry.register<DateTime>(DateHandler());
  TypeHandlerRegistry.register<User>(UserHandler());
  print('   Handlers registered for DateTime and User.\n');

  // 2. Simulate Request Handling (Deserialization)
  print('2. Simulating Request (Deserialization)...');
  
  // Simulate incoming JSON body
  final incomingBody = {'name': 'Charlie', 'age': 28};
  
  final request = DsCustomMiddleWareRequest(
    'POST',
    Uri.parse('/users'),
    {'Content-Type': 'application/json'},
    incomingBody, 
    {},
    routeParams: {}
  );

  try {
    // Deserialize body using registry
    final user = request.bodyAs<User>();
    print('   Request Body: $incomingBody');
    print('   Deserialized: $user');
    
    if (user.name == 'Charlie' && user.age == 28) {
        print('   [SUCCESS] User deserialized correctly.');
    } else {
        print('   [FAILURE] User deserialization incorrect.');
    }
  } catch (e) {
    print('   [ERROR] Deserialization failed: $e');
  }
  print('\n');

  // 3. Simulate Response Handling (Serialization)
  print('3. Simulating Response (Serialization)...');
  
  final responseUser = User('Alice', 32);
  final timestamp = DateTime.now().toUtc();
  
  // Create response with object
  final response = DsCustomMiddleWareResponse.ok({
    'user': responseUser,
    'timestamp': timestamp,
    // Note: The map itself isn't a custom type, 
    // but we want to see if we can handle nested? 
    // Current implementation only checks top-level type in Registry.serialize().
    // So top level map won't be serialized by registry.
    // However, if we pass the User object directly:
  });
  print('   Complex Body:    ${response.body}');
  
  // Test direct object response
  final directResponse = DsCustomMiddleWareResponse.ok(responseUser);
  
  print('   Original Object: $responseUser');
  print('   Response Body:   ${directResponse.body}');
    
  if (directResponse.body is Map<String, dynamic> && 
      directResponse.body['name'] == 'Alice') {
      print('   [SUCCESS] User serialized correctly to Map.');
  } else {
      print('   [FAILURE] User serialization incorrect: ${directResponse.body}');
  }
  
  // Test DateTime response
  final dateResponse = DsCustomMiddleWareResponse.ok(timestamp);
  print('   Original Date:   $timestamp');
  print('   Response Body:   ${dateResponse.body}');
  
   if (dateResponse.body is String) {
      print('   [SUCCESS] DateTime serialized correctly to String.');
  } else {
      print('   [FAILURE] DateTime serialization incorrect.');
  }

  print('\n--- End of Example ---');
}
