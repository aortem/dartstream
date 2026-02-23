import 'package:ds_concurrency/src/isolate_task_message.dart';

/// Interface for handling responses from worker isolates.
abstract class IsolateTaskResponseHandler {
  void handleResponse(IsolateTaskResponse response);
}
