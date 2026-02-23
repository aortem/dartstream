import 'dart:async';
import 'dart:isolate';

import 'package:ds_concurrency/src/isolate_task_message.dart';

/// The entry point for a worker isolate.
/// 
/// [mainSendPort] is the Port to send responses back to the main isolate.
void isolateWorkerEntry(SendPort mainSendPort) {
  final mainReceivePort = ReceivePort();
  
  // Handshake: Send the worker's commands SendPort to the main isolate
  mainSendPort.send(mainReceivePort.sendPort);
  print('IsolateWorker: Handshake sent.');

  // Listen for task messages
  mainReceivePort.listen((message) async {
    if (message is IsolateTaskMessage) {
      try {
        final result = await _executeTask(message);
        mainSendPort.send(IsolateTaskResponse(
          taskId: message.taskId,
          success: true,
          result: result,
        ));
        print('IsolateWorker: Task ${message.taskId} completed.');
      } catch (e) {
        mainSendPort.send(IsolateTaskResponse(
          taskId: message.taskId,
          success: false,
          error: e.toString(),
          // stackTrace could be sent but IsolateTaskResponse needs to be sendable
        ));
      }
    }
  });
}

/// Executes the task based on its type.
/// 
/// This function can be extended to dispatch to different handlers.
Future<dynamic> _executeTask(IsolateTaskMessage message) async {
  switch (message.taskType) {
    case 'echo':
      return message.payload;
    case 'cpu_heavy':
      // simulate cpu heavy task
      return _fibonacci(message.payload['n'] as int);
    default:
      throw Exception('Unknown task type: ${message.taskType}');
  }
}

int _fibonacci(int n) {
  if (n <= 1) return n;
  return _fibonacci(n - 1) + _fibonacci(n - 2);
}
