import 'package:flutter/material.dart';
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:google_auth_provider/ds_firebase_auth_export.dart';
import 'core/ds_standard_web_core.dart';
import 'src/config/app_config.dart';
import 'src/features/auth/auth_demo.dart';

void main() {
  runApp(const DartStreamAuthDemo());
}

/// Main application widget for DartStream Auth Demo.
class DartStreamAuthDemo extends StatefulWidget {
  /// Creates the DartStream Auth Demo widget.
  const DartStreamAuthDemo({super.key});

  @override
  State<DartStreamAuthDemo> createState() => _DartStreamAuthDemoState();
}

class _DartStreamAuthDemoState extends State<DartStreamAuthDemo> {
  late final DSStandardWebCore _core;
  late final DSAuthManager _authManager;
  bool _initialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _initializeDartStream(BuildContext context) async {
    try {
      // Initialize core
      _core = DSStandardWebCore();

      // Create and register Firebase auth provider
      final firebaseProvider = DSFirebaseAuthProvider(
        projectId: AppConfig.projectId,
        privateKeyPath: AppConfig.privateKeyPath,
      );

      // Create metadata for provider
      final metadata = DSAuthProviderMetadata(
        type: 'firebase',
        region: 'global',
        clientId: AppConfig.projectId,
      );

      // Register provider with auth manager
      DSAuthManager.registerProvider('firebase', firebaseProvider, metadata);

      // Initialize auth manager with registered provider
      _authManager = DSAuthManager('firebase');

      // Initialize core with auth manager
      await _core.initialize(
        config: {
          'auth': {
            'manager': _authManager,
          }
        },
        context: context, // Pass the BuildContext from the build method
      );

      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized && _error == null) {
      _initializeDartStream(context); // Pass BuildContext here
    }

    if (!_initialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_error != null) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error initializing DartStream: $_error'),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DartStream Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: AuthDemo(authManager: _authManager),
    );
  }

  @override
  void dispose() {
    _core.dispose();
    super.dispose();
  }
}
