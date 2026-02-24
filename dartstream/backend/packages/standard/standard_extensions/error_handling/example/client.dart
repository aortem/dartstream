import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final client = HttpClient();
  final baseUrl = 'http://localhost:8080';

  print('--- Error Handling Demo Client ---');

  await _testEndpoint(client, '$baseUrl/hello', 'Success Case');
  await _testEndpoint(client, '$baseUrl/error/notfound', '404 Not Found');
  await _testEndpoint(client, '$baseUrl/error/validation', '400 Validation Error');
  await _testEndpoint(client, '$baseUrl/error/unauthorized', '401 Unauthorized');
  await _testEndpoint(client, '$baseUrl/error/crash', '500 Internal Server Error');

  client.close();
}

Future<void> _testEndpoint(HttpClient client, String url, String label) async {
  print('\nTesting: $label ($url)');
  try {
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();

    print('Status Code: ${response.statusCode}');
    print('Response Body: $body');
  } catch (e) {
    print('Request Failed: $e');
  }
}
