// ignore_for_file: depend_on_referenced_packages

import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:firebase_dart_admin_auth_sdk/src/http_response.dart';

void main() {
  group('HttpResponse', () {
    test('constructor should initialize correctly', () {
      final response =
          HttpResponse(statusCode: 200, body: {'message': 'Success'});

      expect(response.statusCode, equals(200));
      expect(response.body, containsPair('message', 'Success'));
    });

    test('toMap should convert the object to a Map', () {
      final response =
          HttpResponse(statusCode: 200, body: {'message': 'Success'});

      final map = response.toMap();
      expect(map, isA<Map<String, dynamic>>());
      expect(map['statusCode'], equals(200));
      expect(map['body'], containsPair('message', 'Success'));
    });

    test('toJson should convert the object to a JSON string', () {
      final response =
          HttpResponse(statusCode: 200, body: {'message': 'Success'});

      final jsonString = response.toJson();
      expect(jsonString, isA<String>());
      expect(jsonString,
          equals('{"statusCode":200,"body":{"message":"Success"}}'));
    });

    test('fromMap should create an instance from a Map', () {
      final map = {
        'statusCode': 200,
        'body': {'message': 'Success'}
      };

      final response = HttpResponse.fromMap(map);
      expect(response.statusCode, equals(200));
      expect(response.body, containsPair('message', 'Success'));
    });

    test('fromJson should create an instance from a JSON string', () {
      final jsonString = '{"statusCode":200,"body":{"message":"Success"}}';

      final response = HttpResponse.fromJson(jsonString);
      expect(response.statusCode, equals(200));
      expect(response.body, containsPair('message', 'Success'));
    });

    test('fromMap should throw an error for invalid map input', () {
      final invalidMap = {'statusCode': 200}; // Missing 'body' key

      expect(
        () => HttpResponse.fromMap(invalidMap),
        throwsA(isA<TypeError>()), // Ensure it throws a TypeError
      );
    });

    test('fromJson should throw an error for invalid JSON string', () {
      final invalidJsonString = '{"statusCode":200}'; // Missing 'body'

      expect(
        () => HttpResponse.fromJson(invalidJsonString),
        throwsA(isA<TypeError>()), // Ensure it throws a TypeError
      );
    });
  });
}
