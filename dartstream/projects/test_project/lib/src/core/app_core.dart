import 'package:ds_standard_engine/ds_standard_engine.dart';

class AppCore {
  final DSStandardCore core;
  
  AppCore({required this.core});
  
  Future<void> start() async {
    // Register your extensions here
    await registerExtensions();
    
    // Start the framework
    core.start();
  }
  
  Future<void> registerExtensions() async {
    // Extensions will be auto-discovered and registered
    // You can manually register additional extensions here
  }
}
