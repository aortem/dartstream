import 'package:test/test.dart';
import 'package:ds_demo_client/ds_demo_client.dart';

void main() {
  test('generated client records requests via transport', () async {
    final transport = DSMemoryTransport();
    final client = DSDemoClient(
      transport: transport,
      baseUrl: 'https://example.test',
    );

    final response = await client.getHealth();

    expect(response.statusCode, 200);
    expect(transport.requests, isNotEmpty);
    expect(transport.requests.first.path, startsWith('https://example.test'));
  });
}
