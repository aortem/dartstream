/// A structured message for communicating between the main isolate and worker isolates.
class IsolateTaskMessage {
  /// Unique identifier for the task.
  final String taskId;

  /// The type of task to perform.
  /// Workers can use this to route to specific handlers.
  final String taskType;

  /// The payload associated with the task.
  /// Must be JSON-encodable/sendable across isolates.
  final Map<String, dynamic> payload;

  /// Creates a new [IsolateTaskMessage].
  const IsolateTaskMessage({
    required this.taskId,
    required this.taskType,
    required this.payload,
  });

  /// Creates a [IsolateTaskMessage] from a Map.
  factory IsolateTaskMessage.fromMap(Map<String, dynamic> map) {
    return IsolateTaskMessage(
      taskId: map['taskId'] as String,
      taskType: map['taskType'] as String,
      payload: map['payload'] as Map<String, dynamic>,
    );
  }

  /// Converts the message to a Map.
  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'taskType': taskType,
      'payload': payload,
    };
  }

  @override
  String toString() => 'IsolateTaskMessage(taskId: $taskId, taskType: $taskType)';
}

/// A structured message for the response from a worker.
class IsolateTaskResponse {
  final String taskId;
  final bool success;
  final dynamic result;
  final String? error;

  IsolateTaskResponse({
    required this.taskId,
    required this.success,
    this.result,
    this.error,
  });
}
