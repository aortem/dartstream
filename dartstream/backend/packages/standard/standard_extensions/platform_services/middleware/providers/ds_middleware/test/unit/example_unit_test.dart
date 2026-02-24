import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart' as mt;
import 'package:ds_middleware/app/models/ds_custom_middleware_model.dart';

abstract class DatabaseService {
  Future<Map<String, dynamic>?> getUser(String id);
}

class UserService {
  final DatabaseService _db;
  UserService(this._db);
  Future<String> getUserName(String id) async {
    final user = await _db.getUser(id);
    if (user == null) return 'Guest';
    return user['name'] as String;
  }
}

class MockDatabaseService extends mt.Mock implements DatabaseService {}

void main() {
  group('UserService (Unit Test with Mocktail)', () {
    late MockDatabaseService mockDb;
    late UserService userService;

    setUp(() {
      mockDb = MockDatabaseService();
      userService = UserService(mockDb);
    });

    test('returns "Guest" when user is not found', () async {
      mt.when(() => mockDb.getUser(mt.any())).thenAnswer((_) async => null);
      final result = await userService.getUserName('unknown_id');
      expect(result, equals('Guest'));
    });

    test('returns user name when user is found', () async {
      mt.when(() => mockDb.getUser('123'))
          .thenAnswer((_) async => {'name': 'Alice'});
      final result = await userService.getUserName('123');
      expect(result, equals('Alice'));
    });
  });
}
