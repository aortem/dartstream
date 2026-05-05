import 'ds_orm_models.dart';
import 'ds_orm_repository.dart';

/// Adapter interface for ORM integrations in DartStream.
abstract class DSOrmAdapter {
  /// Initializes the adapter with provider-specific configuration.
  Future<void> initialize(Map<String, Object?> config);

  /// Returns a typed repository for an entity.
  DSOrmRepository<T> repository<T>(String entityName);

  /// Returns known migrations from the underlying ORM.
  Future<List<DSOrmMigration>> listMigrations();

  /// Applies pending migrations when the adapter supports it.
  Future<void> migrate({int? targetVersion});

  /// Returns the native ORM client/session when available.
  Object? getNativeClient();

  /// Releases adapter resources.
  Future<void> dispose();
}
