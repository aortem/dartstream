import 'package:ds_orm_base/ds_orm_base.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

class FakeRepository implements DSOrmRepository<Map<String, Object?>> {
  final Map<Object, Map<String, Object?>> records = {};

  @override
  Future<Map<String, Object?>> create(Map<String, Object?> values) async {
    final id = values['id'] ?? records.length + 1;
    records[id] = values;
    return values;
  }

  @override
  Future<void> delete(Object id) async {
    records.remove(id);
  }

  @override
  Future<Map<String, Object?>?> findById(Object id) async {
    return records[id];
  }

  @override
  Future<List<Map<String, Object?>>> query(DSOrmQuery query) async {
    return records.values.toList();
  }

  @override
  Future<Map<String, Object?>> update(Object id, DSOrmMutation mutation) async {
    final updated = {...?records[id], ...mutation.values};
    records[id] = updated;
    return updated;
  }
}

class FakeOrmAdapter implements DSOrmAdapter {
  final FakeRepository repositoryInstance = FakeRepository();

  @override
  Future<void> initialize(Map<String, Object?> config) async {}

  @override
  Object? getNativeClient() => null;

  @override
  Future<List<DSOrmMigration>> listMigrations() async {
    return [DSOrmMigration(version: 1, description: 'Initial schema')];
  }

  @override
  Future<void> migrate({int? targetVersion}) async {}

  @override
  DSOrmRepository<T> repository<T>(String entityName) {
    return repositoryInstance as DSOrmRepository<T>;
  }

  @override
  Future<void> dispose() async {}
}

void main() {
  test('registers and returns an ORM adapter', () async {
    final adapter = FakeOrmAdapter();
    DSOrmManager.registerAdapter(
      'fake-orm',
      adapter,
      DSOrmAdapterMetadata(
        type: 'fake',
        capabilities: const ['repository', 'migration'],
      ),
    );

    await DSOrmManager.initializeAdapter('fake-orm', {});
    final repo = DSOrmManager.getAdapter(
      'fake-orm',
    ).repository<Map<String, Object?>>('users');
    final created = await repo.create({'id': 1, 'email': 'user@example.com'});

    expect(created['email'], 'user@example.com');
  });
}
