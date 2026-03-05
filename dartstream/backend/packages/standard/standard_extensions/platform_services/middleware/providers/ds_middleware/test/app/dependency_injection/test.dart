import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:ds_middleware/app/dependency_injection/ds_service_container.dart';

void main() {
  group('DsServiceContainer', () {
    test('resolves singleton as same instance', () {
      final container = DsServiceContainer();
      container.registerSingleton<CounterService>((_) => CounterService());

      final first = container.resolve<CounterService>();
      final second = container.resolve<CounterService>();

      expect(identical(first, second), isTrue);
    });

    test('resolves transient as new instance', () {
      final container = DsServiceContainer();
      container.registerTransient<CounterService>((_) => CounterService());

      final first = container.resolve<CounterService>();
      final second = container.resolve<CounterService>();

      expect(identical(first, second), isFalse);
    });

    test('resolves scoped service per scope', () {
      final container = DsServiceContainer();
      container.registerScoped<CounterService>((_) => CounterService());

      final scopeOne = container.createScope();
      final scopeTwo = container.createScope();

      final scopeOneFirst = scopeOne.resolve<CounterService>();
      final scopeOneSecond = scopeOne.resolve<CounterService>();
      final scopeTwoValue = scopeTwo.resolve<CounterService>();

      expect(identical(scopeOneFirst, scopeOneSecond), isTrue);
      expect(identical(scopeOneFirst, scopeTwoValue), isFalse);
    });

    test('supports constructor injection via resolver', () {
      final container = DsServiceContainer();
      container.registerInstance<ConfigService>(ConfigService('prod'));
      container.registerTransient<AppService>(
        (resolver) => AppService(resolver.resolve<ConfigService>()),
      );

      final service = container.resolve<AppService>();
      expect(service.mode, 'prod');
    });

    test('throws when scoped service is resolved from root', () {
      final container = DsServiceContainer();
      container.registerScoped<CounterService>((_) => CounterService());

      expect(
        () => container.resolve<CounterService>(),
        throwsA(isA<StateError>()),
      );
    });

    test('disposes scoped DsDisposable instances when scope is disposed', () async {
      final container = DsServiceContainer();
      container.registerScoped<DisposableService>((_) => DisposableService());

      final scope = container.createScope();
      final disposable = scope.resolve<DisposableService>();
      expect(disposable.disposed, isFalse);

      await scope.dispose();
      expect(disposable.disposed, isTrue);

      expect(
        () => scope.resolve<DisposableService>(),
        throwsA(isA<StateError>()),
      );
    });
  });
}

class CounterService {
  int value = 0;
}

class ConfigService {
  ConfigService(this.mode);
  final String mode;
}

class AppService {
  AppService(this._config);
  final ConfigService _config;

  String get mode => _config.mode;
}

class DisposableService implements DsDisposable {
  bool disposed = false;

  @override
  Future<void> dispose() async {
    disposed = true;
  }
}
