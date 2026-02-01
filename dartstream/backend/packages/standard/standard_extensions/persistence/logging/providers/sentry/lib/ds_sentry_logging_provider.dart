import 'package:ds_logging_base/ds_logging_base_export.dart';
import 'package:sentry/sentry.dart';

class DSSentryLoggingProvider implements DSLoggingProvider {
  bool _initialized = false;
  bool _breadcrumbsEnabled = true;
  bool _captureInfoAsEvents = false;
  bool _captureWarningsAsEvents = false;

  final List<Future<void>> _pending = [];

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    final dsn = config['dsn'];
    if (dsn is! String || dsn.trim().isEmpty) {
      throw ArgumentError('Sentry DSN is required.');
    }

    _breadcrumbsEnabled = config['breadcrumbsEnabled'] as bool? ?? true;
    _captureInfoAsEvents = config['captureInfoAsEvents'] as bool? ?? false;
    _captureWarningsAsEvents =
        config['captureWarningsAsEvents'] as bool? ?? false;

    final environment = config['environment'] as String?;
    final release = config['release'] as String?;
    final tracesSampleRate = config['tracesSampleRate'];
    final sendDefaultPii = config['sendDefaultPii'] as bool? ?? false;

    await Sentry.init((options) {
      options.dsn = dsn.trim();
      if (environment != null && environment.trim().isNotEmpty) {
        options.environment = environment.trim();
      }
      if (release != null && release.trim().isNotEmpty) {
        options.release = release.trim();
      }
      if (tracesSampleRate is num) {
        options.tracesSampleRate = tracesSampleRate.toDouble();
      }
      options.sendDefaultPii = sendDefaultPii;
    });

    _initialized = true;
  }

  @override
  void info(String message, {Map<String, dynamic>? context}) {
    if (!_initialized) return;
    _addBreadcrumb(message, SentryLevel.info, context);
    if (_captureInfoAsEvents) {
      _captureMessage(message, SentryLevel.info, context);
    }
  }

  @override
  void warn(String message, {Map<String, dynamic>? context}) {
    if (!_initialized) return;
    _addBreadcrumb(message, SentryLevel.warning, context);
    if (_captureWarningsAsEvents) {
      _captureMessage(message, SentryLevel.warning, context);
    }
  }

  @override
  void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    if (!_initialized) return;
    final scope = _scopeFromContext(context);

    if (error != null) {
      _track(
        Sentry.captureException(
          error,
          stackTrace: stackTrace,
          withScope: scope,
        ).then((_) => null),
      );
      return;
    }

    _track(
      Sentry.captureMessage(
        message,
        level: SentryLevel.error,
        withScope: scope,
      ).then((_) => null),
    );
  }

  ScopeCallback? _scopeFromContext(Map<String, dynamic>? context) {
    if (context == null || context.isEmpty) {
      return null;
    }

    return (scope) {
      context.forEach((key, value) {
        scope.setContexts(key, value);
      });
    };
  }

  void _addBreadcrumb(
    String message,
    SentryLevel level,
    Map<String, dynamic>? context,
  ) {
    if (!_breadcrumbsEnabled) {
      return;
    }

    final crumb = Breadcrumb(
      message: message,
      level: level,
      category: 'log',
      data: context,
      type: 'default',
    );

    _track(Sentry.addBreadcrumb(crumb));
  }

  void _captureMessage(
    String message,
    SentryLevel level,
    Map<String, dynamic>? context,
  ) {
    final scope = _scopeFromContext(context);
    _track(
      Sentry.captureMessage(
        message,
        level: level,
        withScope: scope,
      ).then((_) => null),
    );
  }

  void _track(Future<void> future) {
    _pending.add(future);
    future.whenComplete(() => _pending.remove(future));
  }

  @override
  Future<void> flush() async {
    if (_pending.isEmpty) {
      return;
    }

    final pending = List<Future<void>>.from(_pending);
    try {
      await Future.wait(pending);
    } catch (_) {
      // Swallow flush failures.
    }
  }

  @override
  Future<void> dispose() async {
    await flush();
    _initialized = false;
  }
}
