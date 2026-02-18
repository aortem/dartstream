import 'type_handler.dart';

/// Registry to manage and access [TypeHandler]s.
class TypeHandlerRegistry {
  static final Map<Type, TypeHandler> _handlers = {};

  /// Registers a [handler] for type [T].
  static void register<T>(TypeHandler<T> handler) {
    _handlers[T] = handler;
  }

  /// Unregisters the handler for type [T].
  static void unregister<T>() {
    _handlers.remove(T);
  }

  /// Serializes a [value] using a registered handler if available.
  /// Returns the [value] as-is if no handler is found.
  static dynamic serialize(dynamic value) {
    if (value == null) return null;
    var handler = _handlers[value.runtimeType];
    if (handler != null) {
      return handler.serialize(value);
    }
    return value;
  }

  /// Deserializes a [value] to type [T] using a registered handler.
  /// Throws an [Exception] if no handler is registered for [T].
  static T deserialize<T>(dynamic value) {
    var handler = _handlers[T];
    if (handler != null) {
      return handler.deserialize(value) as T;
    }
    throw Exception('No TypeHandler registered for type $T');
  }

  /// Checks if a handler is registered for type [T].
  static bool hasHandler<T>() {
    return _handlers.containsKey(T);
  }
}
