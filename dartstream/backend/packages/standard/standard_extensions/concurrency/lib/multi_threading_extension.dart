import 'dart:async';
import 'dart:io';

import 'package:ds_concurrency/src/isolate_pool_manager.dart';
import 'package:ds_concurrency/src/isolate_task_dispatcher.dart';

export 'package:ds_concurrency/src/isolate_task_message.dart';
export 'package:ds_concurrency/src/isolate_task_dispatcher.dart';

/// Extension for adding multi-threading capabilities to Dartstream.
/// 
/// This extension manages a pool of isolates for background task execution.
class MultiThreadingExtension {
  static const String extensionName = 'multi_threading';

  // Configuration
  final int isolateCount;

  // Components  
  late final IsolatePoolManager _poolManager;
  late IsolateTaskDispatcher _dispatcher;

  // Getter for the dispatcher to be used by other extensions
  IsolateTaskDispatcher get dispatcher => _dispatcher;

  /// Creates a new [MultiThreadingExtension].
  /// 
  /// [isolateCount] defaults to the number of processors if set to 0.
  MultiThreadingExtension({this.isolateCount = 0}); 

  /// Lifecycle method called during framework initialization.
  Future<void> onInitialize() async {
    print('Initializing MultiThreadingExtension...');
    
    final count = isolateCount > 0 ? isolateCount : Platform.numberOfProcessors;
    print('Configuring Isolate Pool with $count workers.');

    _poolManager = IsolatePoolManager(workerCount: count);
    _dispatcher = IsolateTaskDispatcher(_poolManager);
    
    // Wire up the dispatcher to the pool (circular dependency resolution)
    _poolManager.setResponseHandler(_dispatcher);

    await _poolManager.initialize();
    
    // Register IsolateTaskDispatcher (In a real scenario, we would register to DI here)
    // ServiceLocator.registerSingleton<IsolateTaskDispatcher>(_dispatcher);
    print('MultiThreadingExtension initialized successfully.');
  }

  /// Lifecycle method called during framework shutdown.
  Future<void> onDispose() async {
    print('Disposing MultiThreadingExtension...');
    _poolManager.dispose();
  }
}
