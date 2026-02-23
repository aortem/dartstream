import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:ds_concurrency/multi_threading_extension.dart';

void main() {
  group('MultiThreadingExtension Integration', () {
    late MultiThreadingExtension extension;

    setUp(() {
      extension = MultiThreadingExtension(isolateCount: 2);
    });

    tearDown(() async {
      await extension.onDispose();
    });

    test('initializes and disposes correctly', () async {
      await extension.onInitialize();
      // If no exception, it passed initialization
      expect(extension.dispatcher, isNotNull);
    });

    test('dispatches simple echo task', () async {
      await extension.onInitialize();
      
      final message = IsolateTaskMessage(
        taskId: 'test-1',
        taskType: 'echo',
        payload: {'data': 'hello world'},
      );

      final result = await extension.dispatcher.dispatch(message);
      expect(result, equals({'data': 'hello world'}));
    });

    test('dispatches cpu heavy task', () async {
      await extension.onInitialize();
      
      final message = IsolateTaskMessage(
        taskId: 'test-2',
        taskType: 'cpu_heavy',
        payload: {'n': 10},
      );

      final result = await extension.dispatcher.dispatch(message);
      expect(result, equals(55)); // fib(10) = 55
    });
    
    test('handles multiple tasks concurrently', () async {
        await extension.onInitialize();
        
        final futures = <Future>[];
        for (var i = 0; i < 10; i++) {
            futures.add(extension.dispatcher.dispatch(
                IsolateTaskMessage(
                    taskId: 'concurrent-$i', 
                    taskType: 'cpu_heavy', 
                    payload: {'n': 10}
                )
            ));
        }
        
        final results = await Future.wait(futures);
        expect(results.length, equals(10));
        expect(results.every((r) => r == 55), isTrue);
    });
  });
}
