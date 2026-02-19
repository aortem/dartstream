import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:ds_concurrency/multi_threading_extension.dart';

void main(List<String> args) async {
  // 1. Initialize MultiThreadingExtension
  final concurrencyExt = MultiThreadingExtension(isolateCount: 2);
  await concurrencyExt.onInitialize();

  // 2. Setup Router
  final app = Router();

  // Endpoint: /echo/<message>
  app.get('/echo/<message>', (Request request, String message) async {
    print('[Main Thread] Received echo request: $message');
    
    final task = IsolateTaskMessage(
      taskId: 'echo-${DateTime.now().millisecondsSinceEpoch}',
      taskType: 'echo',
      payload: {'data': message},
    );
    
    try {
      final result = await concurrencyExt.dispatcher.dispatch(task);
      return Response.ok('Echo Result: ${result['data']}\n');
    } catch (e) {
      return Response.internalServerError(body: 'Error: $e');
    }
  });

  // Endpoint: /fib/<n>
  app.get('/fib/<n>', (Request request, String nStr) async {
    final n = int.tryParse(nStr) ?? 10;
    print('[Main Thread] Received fib request: $n');
    
    final task = IsolateTaskMessage(
      taskId: 'fib-${DateTime.now().millisecondsSinceEpoch}',
      taskType: 'cpu_heavy',
      payload: {'n': n},
    );
    
    try {
      final result = await concurrencyExt.dispatcher.dispatch(task);
      return Response.ok('Fibonacci($n) = $result\n');
    } catch (e) {
      return Response.internalServerError(body: 'Error: $e');
    }
  });

  // Serve static files from 'web' directory (Fallback)
  final staticHandler = createStaticHandler('web', defaultDocument: 'index.html');
  app.mount('/', staticHandler);

  // 3. Start Server
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(app);
  final server = await serve(handler, InternetAddress.loopbackIPv4, 8080);
  print('Server listening on http://${server.address.host}:${server.port}');
  print('Press Ctrl+C to stop.');
  
  // Handle graceful shutdown
  ProcessSignal.sigint.watch().listen((_) async {
      print('\nShutting down...');
      await concurrencyExt.onDispose();
      await server.close();
      exit(0);
  });
}
