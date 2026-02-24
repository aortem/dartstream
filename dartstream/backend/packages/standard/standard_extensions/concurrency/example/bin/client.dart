import 'dart:async';
import 'dart:convert';
import 'dart:io';

void main() async {
  final client = HttpClient();
  final baseUrl = 'http://localhost:8080';

  print('Starting concurrency demo...');

  // 1. Start heavy calculation (Fibonacci 40)
  print('[Client] Sending request to /fib/40 (Heavy Task)...');
  final heavyTaskFuture = _measureRequest(client, '$baseUrl/fib/40', 'Heavy Task');

  // 2. Wait a bit to ensure heavy task is running on server
  await Future.delayed(Duration(milliseconds: 500));

  // 3. Send light request (Echo)
  print('[Client] Sending request to /echo/concurrent (Light Task)...');
  final lightTaskFuture = _measureRequest(client, '$baseUrl/echo/concurrent', 'Light Task');

  // Wait for both
  await Future.wait([heavyTaskFuture, lightTaskFuture]);

  print('Demo complete.');
  client.close();
}

Future<void> _measureRequest(HttpClient client, String url, String name) async {
  final start = DateTime.now();
  try {
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    final end = DateTime.now();
    final duration = end.difference(start).inMilliseconds;

    print('[$name] Completed in ${duration}ms at ${end.toIso8601String()}');
    print('   Response: $body');
  } catch (e) {
    print('[$name] Failed: $e');
  }
}
