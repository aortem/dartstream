import 'package:test/test.dart';
import 'package:test_project/src/models/user.dart';

void main() {
  group('User', () {
    test('creates instance', () {
      final item = User(
        id: '1',
        name: 'Test',
        createdAt: DateTime.now(),
      );
      
      expect(item.id, '1');
      expect(item.name, 'Test');
      expect(item.updatedAt, isNull);
    });
    
    test('converts to/from JSON', () {
      final now = DateTime.now();
      final item = User(
        id: '1',
        name: 'Test',
        createdAt: now,
      );
      
      final json = item.toJson();
      expect(json['id'], '1');
      expect(json['name'], 'Test');
      
      final restored = User.fromJson(json);
      expect(restored.id, item.id);
      expect(restored.name, item.name);
    });
    
    test('copies with modifications', () {
      final item = User(
        id: '1',
        name: 'Original',
        createdAt: DateTime.now(),
      );
      
      final copied = item.copyWith(name: 'Modified');
      expect(copied.id, item.id);
      expect(copied.name, 'Modified');
      expect(copied.createdAt, item.createdAt);
    });
  });
}
