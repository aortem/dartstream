typedef DsFactory<T> = T Function(DsServiceResolver resolver);

enum DsServiceLifetime {
  singleton,
  transient,
  scoped,
}

class DsServiceDescriptor<T extends Object> {
  const DsServiceDescriptor({
    required this.factory,
    required this.lifetime,
  });

  final DsFactory<T> factory;
  final DsServiceLifetime lifetime;
}

abstract class DsServiceResolver {
  T resolve<T extends Object>();
  T? tryResolve<T extends Object>();
  bool isRegistered<T extends Object>();
}

class DsServiceContainer implements DsServiceResolver {
  DsServiceContainer();

  final Map<Type, DsServiceDescriptor<Object>> _descriptors =
      <Type, DsServiceDescriptor<Object>>{};
  final Map<Type, Object> _singletons = <Type, Object>{};

  void registerSingleton<T extends Object>(DsFactory<T> factory) {
    _register<T>(
      DsServiceDescriptor<T>(
        factory: factory,
        lifetime: DsServiceLifetime.singleton,
      ),
    );
  }

  void registerScoped<T extends Object>(DsFactory<T> factory) {
    _register<T>(
      DsServiceDescriptor<T>(
        factory: factory,
        lifetime: DsServiceLifetime.scoped,
      ),
    );
  }

  void registerTransient<T extends Object>(DsFactory<T> factory) {
    _register<T>(
      DsServiceDescriptor<T>(
        factory: factory,
        lifetime: DsServiceLifetime.transient,
      ),
    );
  }

  void registerInstance<T extends Object>(T instance) {
    _register<T>(
      DsServiceDescriptor<T>(
        factory: (_) => instance,
        lifetime: DsServiceLifetime.singleton,
      ),
    );
    _singletons[T] = instance;
  }

  void _register<T extends Object>(DsServiceDescriptor<T> descriptor) {
    _descriptors[T] = DsServiceDescriptor<Object>(
      factory: (resolver) => descriptor.factory(resolver),
      lifetime: descriptor.lifetime,
    );
  }

  @override
  T resolve<T extends Object>() {
    final descriptor = _descriptors[T];
    if (descriptor == null) {
      throw StateError('Service not registered: $T');
    }

    switch (descriptor.lifetime) {
      case DsServiceLifetime.singleton:
        return (_singletons[T] ??= descriptor.factory(this)) as T;
      case DsServiceLifetime.transient:
        return descriptor.factory(this) as T;
      case DsServiceLifetime.scoped:
        throw StateError(
          'Scoped service $T cannot be resolved from root container. '
          'Create a scope first.',
        );
    }
  }

  @override
  T? tryResolve<T extends Object>() {
    if (!isRegistered<T>()) {
      return null;
    }
    return resolve<T>();
  }

  @override
  bool isRegistered<T extends Object>() => _descriptors.containsKey(T);

  DsServiceScope createScope() => DsServiceScope._(this);
}

class DsServiceScope implements DsServiceResolver {
  DsServiceScope._(this._container);

  final DsServiceContainer _container;
  final Map<Type, Object> _scopedInstances = <Type, Object>{};
  bool _disposed = false;

  @override
  T resolve<T extends Object>() {
    _ensureNotDisposed();

    final descriptor = _container._descriptors[T];
    if (descriptor == null) {
      throw StateError('Service not registered: $T');
    }

    switch (descriptor.lifetime) {
      case DsServiceLifetime.singleton:
        return _container.resolve<T>();
      case DsServiceLifetime.transient:
        return descriptor.factory(this) as T;
      case DsServiceLifetime.scoped:
        return (_scopedInstances[T] ??= descriptor.factory(this)) as T;
    }
  }

  @override
  T? tryResolve<T extends Object>() {
    if (!isRegistered<T>()) {
      return null;
    }
    return resolve<T>();
  }

  @override
  bool isRegistered<T extends Object>() => _container.isRegistered<T>();

  Future<void> dispose() async {
    if (_disposed) {
      return;
    }

    _disposed = true;
    for (final service in _scopedInstances.values) {
      if (service is DsDisposable) {
        await service.dispose();
      }
    }
    _scopedInstances.clear();
  }

  void _ensureNotDisposed() {
    if (_disposed) {
      throw StateError('Service scope has been disposed.');
    }
  }
}

abstract class DsDisposable {
  Future<void> dispose();
}
