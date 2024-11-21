import 'dart:convert';

/// Represents an HTTP response, including the status code and response body.
class HttpResponse {
  /// The HTTP status code returned from the server (e.g., 200 for success, 404 for not found).
  final int statusCode;

  /// The body of the HTTP response, typically a map containing data or a message.
  final Map<String, dynamic> body;

  ///headers
  final Map<String, String> headers;

  /// Constructs a new instance of `HttpResponse`.
  ///
  /// Both [statusCode] and [body] are required parameters.
  ///
  /// Example usage:
  /// ```dart
  /// HttpResponse response = HttpResponse(statusCode: 200, body: {'message': 'Success'});
  /// ```
  HttpResponse({
    required this.statusCode,
    required this.body,
    this.headers = const {},
  });

  /// Converts the `HttpResponse` instance to a Map<String, dynamic>.
  ///
  /// This method is useful for converting the object to a structure that can
  /// be easily converted to a JSON string or for storing as part of a larger map.
  ///
  /// Example usage:
  /// ```dart
  /// Map<String, dynamic> map = response.toMap();
  /// ```
  Map<String, dynamic> toMap() {
    return {
      'statusCode': statusCode,
      'body': body,
    };
  }

  /// Converts the `HttpResponse` instance to a JSON string.
  ///
  /// This method encodes the HTTP response as a JSON string, which is useful
  /// when transmitting or storing the response data in a JSON-compatible format.
  ///
  /// Example usage:
  /// ```dart
  /// String jsonString = response.toJson();
  /// ```
  String toJson() {
    return json.encode(toMap());
  }

  /// Factory constructor to create an `HttpResponse` instance from a Map<String, dynamic>.
  ///
  /// The map must include the keys `statusCode` and `body`. This constructor is
  /// useful when you have a map representation of the response, for instance, when
  /// parsing JSON data.
  ///
  /// Example usage:
  /// ```dart
  /// Map<String, dynamic> map = {'statusCode': 200, 'body': {'message': 'Success'}};
  /// HttpResponse response = HttpResponse.fromMap(map);
  /// ```
  factory HttpResponse.fromMap(Map<String, dynamic> map) {
    return HttpResponse(
      statusCode: map['statusCode'],
      body: Map<String, dynamic>.from(map['body']),
    );
  }

  /// Factory constructor to create an `HttpResponse` instance from a JSON string.
  ///
  /// This method first decodes the JSON string and then converts it into an
  /// `HttpResponse` object. It is useful when the HTTP response is received
  /// as a JSON string.
  ///
  /// Example usage:
  /// ```dart
  /// String jsonString = '{"statusCode": 200, "body": {"message": "Success"}}';
  /// HttpResponse response = HttpResponse.fromJson(jsonString);
  /// ```
  factory HttpResponse.fromJson(String source) {
    return HttpResponse.fromMap(json.decode(source));
  }
}
