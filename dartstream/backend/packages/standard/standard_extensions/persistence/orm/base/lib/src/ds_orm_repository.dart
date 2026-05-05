import 'ds_orm_models.dart';

/// Typed repository contract exposed by ORM adapters.
abstract class DSOrmRepository<T> {
  Future<T> create(Map<String, Object?> values);

  Future<T?> findById(Object id);

  Future<List<T>> query(DSOrmQuery query);

  Future<T> update(Object id, DSOrmMutation mutation);

  Future<void> delete(Object id);
}
