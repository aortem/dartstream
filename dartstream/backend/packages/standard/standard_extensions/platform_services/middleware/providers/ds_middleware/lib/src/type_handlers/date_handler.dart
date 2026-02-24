import 'type_handler.dart';

/// Handles conversion between [DateTime] and ISO 8601 String.
class DateHandler implements TypeHandler<DateTime> {
  @override
  dynamic serialize(DateTime value) {
    return value.toIso8601String();
  }

  @override
  DateTime deserialize(dynamic value) {
    if (value is String) {
      return DateTime.parse(value);
    }
    throw FormatException(
      'Expected String for DateTime deserialization, got ${value.runtimeType}',
    );
  }

  @override
  bool canHandle(dynamic value) => value is DateTime;
}
