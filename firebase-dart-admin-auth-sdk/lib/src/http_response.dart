import 'dart:convert';

class HttpResponse {
  final int statusCode;
  final Map<String, dynamic> body;

  HttpResponse({required this.statusCode, required this.body});

  Map<String, dynamic> toMap() {
    return {
      'statusCode': statusCode,
      'body': body,
    };
  }

  // Convert HttpResponse to a JSON string
  String toJson() {
    return json.encode(toMap());
  }

  // Factory constructor to create HttpResponse from a Map<String, dynamic>
  factory HttpResponse.fromMap(Map<String, dynamic> map) {
    return HttpResponse(
      statusCode: map['statusCode'],
      body: Map<String, dynamic>.from(map['body']),
    );
  }

  // Factory constructor to create HttpResponse from a JSON string
  factory HttpResponse.fromJson(String source) {
    return HttpResponse.fromMap(json.decode(source));
  }
}
