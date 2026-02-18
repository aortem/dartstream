import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:mocktail/mocktail.dart' as mt;

// --- 1. The Code Under Test ---

// A simple dependency we want to mock
abstract class DatabaseService {
  Future<Map<String, dynamic>?> getUser(String id);
}

// The service we are testing
class UserService {
  final DatabaseService _db;

  UserService(this._db);

  Future<String> getUserName(String id) async {
    final user = await _db.getUser(id);
    if (user == null) return 'Guest';
    return user['name'] as String;
  }
}

// --- 2. The Mock Definitions ---

// Create a Mock class using Mocktail
class MockDatabaseService extends mt.Mock implements DatabaseService {}

// --- 3. The Tests ---

void main() {
  group('UserService (Unit Test with Mocktail)', () {
    late MockDatabaseService mockDb;
    late UserService userService;

    setUpAll(() {
       // Register fallback values if needed for custom types
       // mt.registerFallbackValue(CustomType());
    });

    setUp(() {
      mockDb = MockDatabaseService();
      userService = UserService(mockDb);
    });

    test('returns "Guest" when user is not found', () async {
      // Stub the mock to return null
      mt.when(() => mockDb.getUser(mt.any())).thenAnswer((_) async => null);

      final result = await userService.getUserName('unknown_id');

      expect(result, equals('Guest'));
      mt.verify(() => mockDb.getUser('unknown_id')).called(1);
    });

    test('returns user name when user is found', () async {
      // Stub the mock to return a user
      mt.when(() => mockDb.getUser('123'))
          .thenAnswer((_) async => {'name': 'Alice', 'id': '123'});

      final result = await userService.getUserName('123');

      expect(result, equals('Alice'));
      mt.verify(() => mockDb.getUser('123')).called(1);
    });
  });
}
