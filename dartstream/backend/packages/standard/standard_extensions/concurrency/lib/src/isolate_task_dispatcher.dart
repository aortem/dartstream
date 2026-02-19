import 'dart:async';
import 'package:ds_concurrency/src/isolate_task_message.dart';
import 'package:ds_concurrency/src/isolate_pool_manager.dart';

import 'package:ds_concurrency/src/isolate_task_response_handler.dart';

/// Routes tasks to the pool and manages responses from workers.
class IsolateTaskDispatcher implements IsolateTaskResponseHandler {
  final IsolatePoolManager _poolManager;
  final Map<String, Completer<dynamic>> _pendingTasks = {};

  IsolateTaskDispatcher(this._poolManager);

  Future<dynamic> dispatch(IsolateTaskMessage message) {
      final completer = Completer<dynamic>();
      _pendingTasks[message.taskId] = completer;

      try {
        _poolManager.dispatch(message);
      } catch (e) {
          _pendingTasks.remove(message.taskId);
          throw Exception('Failed to dispatch task: $e');
      }

      return completer.future;
  }

  @override
  void handleResponse(IsolateTaskResponse response) {
      if (_pendingTasks.containsKey(response.taskId)) {
          final completer = _pendingTasks.remove(response.taskId)!;
          if (response.success) {
              completer.complete(response.result);
          } else {
              completer.completeError(response.error!);
          }
      } else {
        // Log unexpected or late response
        print('Received response for unknown/expired task: ${response.taskId}');
      }
  }
}
