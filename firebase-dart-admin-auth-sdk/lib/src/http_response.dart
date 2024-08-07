class HttpResponse {
  final int statusCode;
  final Map<String, dynamic> body;

  HttpResponse({required this.statusCode, required this.body});
}
