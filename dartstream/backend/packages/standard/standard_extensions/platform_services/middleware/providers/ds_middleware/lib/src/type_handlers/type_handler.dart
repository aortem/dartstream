/// Interface for handling custom types in requests and responses.
abstract class TypeHandler<T> {
  /// Converts a value of type [T] to a serializable format (e.g., String, Map).
  dynamic serialize(T value);

  /// Converts a serialized value (e.g., String, Map) to type [T].
  T deserialize(dynamic value);

  /// Checks if this handler can specifically handle the given value.
  /// This is optional and mainly used for runtime type checking if T is dynamic.
  bool canHandle(dynamic value) => value is T;
}
