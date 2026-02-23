import 'dart:async';
import 'dart:isolate';

import 'package:ds_concurrency/src/isolate_task_message.dart';
import 'package:ds_concurrency/src/isolate_worker.dart';
import 'package:ds_concurrency/src/isolate_task_response_handler.dart';

/// Manages a pool of worker isolates.
class IsolatePoolManager {
  final int workerCount;
  final List<Isolate> _isolates = [];
  final List<SendPort> _workerSendPorts = [];
  
  // Round-robin index
  int _currentWorkerIndex = 0;

  late final IsolateTaskResponseHandler _responseHandler;

  IsolatePoolManager({required this.workerCount});

  void setResponseHandler(IsolateTaskResponseHandler handler) {
    _responseHandler = handler;
  }

  /// Initializes the pool by spawning workers.
  Future<void> initialize() async {
    print('Initializing IsolatePoolManager with $workerCount workers...');
    for (int i = 0; i < workerCount; i++) {
        await _spawnWorker(i);
    }
  }

  Future<void> _spawnWorker(int index) async {
    final receivePort = ReceivePort();
    
    // Spawn the isolate
    // We pass the sendPort of our receivePort so the worker can send back its command port
    await Isolate.spawn(
      isolateWorkerEntry,
      receivePort.sendPort,
      debugName: 'IsolateWorker-$index',
    );

    // Wait for the worker to send its SendPort
    final Completer<SendPort> handshakeCompleter = Completer<SendPort>();

    receivePort.listen((message) {
      if (message is SendPort) {
        if (!handshakeCompleter.isCompleted) {
          handshakeCompleter.complete(message);
        }
      } else if (message is IsolateTaskResponse) {
        _responseHandler.handleResponse(message);
      } else {
        print('IsolatePoolManager: Received unknown message from worker $index: $message');
      }
    });

    try {
      final workerSendPort = await handshakeCompleter.future.timeout(Duration(seconds: 30));
      _workerSendPorts.add(workerSendPort);
    } catch (e) {
      print('IsolatePoolManager: Failed to initialize worker $index: $e');
      rethrow;
    }
    
    print('Worker $index spawned and ready.');
  }


  /// Dispatches a message to a worker using round-robin strategy.
  void dispatch(IsolateTaskMessage message) {
    if (_workerSendPorts.isEmpty) {
        throw StateError('Isolate pool is not initialized or has no workers.');
    }

    final workerPort = _workerSendPorts[_currentWorkerIndex];
    workerPort.send(message);

    // Update round-robin index
    _currentWorkerIndex = (_currentWorkerIndex + 1) % _workerSendPorts.length;
  }

  /// Shuts down all isolates in the pool.
  void dispose() {
    for (var isolate in _isolates) {
      isolate.kill(priority: Isolate.immediate);
    }
    _isolates.clear();
    _workerSendPorts.clear();
    print('IsolatePoolManager disposed.');
  }
}
