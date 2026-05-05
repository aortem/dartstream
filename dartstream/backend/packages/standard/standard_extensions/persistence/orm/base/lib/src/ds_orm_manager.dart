import 'ds_orm_adapter.dart';
import 'ds_orm_models.dart';

/// Central registry and lifecycle manager for DartStream ORM adapters.
class DSOrmManager {
  static final Map<String, DSOrmAdapter> _adapters = {};
  static final Map<String, DSOrmAdapterMetadata> _metadata = {};

  static void registerAdapter(
    String name,
    DSOrmAdapter adapter,
    DSOrmAdapterMetadata metadata,
  ) {
    if (_adapters.containsKey(name)) {
      throw DSOrmError(
        'Adapter already registered: $name',
        code: 'adapter_already_registered',
      );
    }
    _adapters[name] = adapter;
    _metadata[name] = metadata;
  }

  static List<String> getRegisteredAdapterNames() => _adapters.keys.toList();

  static DSOrmAdapterMetadata? getAdapterMetadata(String adapterName) {
    return _metadata[adapterName];
  }

  static Future<void> initializeAdapter(
    String adapterName,
    Map<String, Object?> config,
  ) {
    return _getAdapter(adapterName).initialize(config);
  }

  static DSOrmAdapter getAdapter(String adapterName) {
    return _getAdapter(adapterName);
  }

  static Future<void> migrate(String adapterName, {int? targetVersion}) {
    return _getAdapter(adapterName).migrate(targetVersion: targetVersion);
  }

  static DSOrmAdapter _getAdapter(String adapterName) {
    final adapter = _adapters[adapterName];
    if (adapter == null) {
      throw DSOrmError(
        'Adapter not registered: $adapterName',
        code: 'adapter_not_registered',
      );
    }
    return adapter;
  }
}
