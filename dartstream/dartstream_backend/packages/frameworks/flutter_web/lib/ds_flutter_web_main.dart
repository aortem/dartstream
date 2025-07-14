import 'package:flutter/material.dart';
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:google_auth_provider/ds_firebase_auth_export.dart';
import 'core/ds_standard_web_core.dart';
import 'src/config/app_config.dart';
import 'src/features/auth/auth_demo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase for web
    debugPrint('Initializing Firebase for Web...');
    await FirebaseApp.initializeAppWithEnvironmentVariables(
      apiKey: AppConfig.apiKey,
      projectId: AppConfig.projectId,
      authdomain: '${AppConfig.projectId}.firebaseapp.com',
      messagingSenderId: AppConfig.messagingSenderId,
      bucketName: AppConfig.storageBucket,
      appId: AppConfig.appId,
    );

    // Get auth instance
    FirebaseApp.instance.getAuth();
    debugPrint('Firebase Auth instance obtained.');

    runApp(const DartStreamAuthDemo());
  } catch (e, stackTrace) {
    debugPrint('Error initializing Firebase: $e');
    debugPrint('StackTrace: $stackTrace');
  }
}

class DartStreamAuthDemo extends StatefulWidget {
  const DartStreamAuthDemo({super.key});

  @override
  State<DartStreamAuthDemo> createState() => _DartStreamAuthDemoState();
}

class _DartStreamAuthDemoState extends State<DartStreamAuthDemo> {
  DSStandardWebCore? _core;
  DSAuthManager? _authManager;
  bool _initialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized && _error == null) {
      _initializeDartStream(context);
    }
  }

  Future<void> _initializeDartStream(BuildContext context) async {
    if (_initialized) return;

    try {
      // Initialize core first
      _core = DSStandardWebCore();

      // Create Firebase provider instance
      final firebaseProvider = DSFirebaseAuthProvider(
        projectId: AppConfig.projectId,
        privateKeyPath: AppConfig.privateKeyPath,
        apiKey: AppConfig.apiKey,
      );

      // Create metadata
      final metadata = DSAuthProviderMetadata(
        type: 'firebase',
        region: 'global',
        clientId: AppConfig.projectId,
      );

      // Initialize provider
      await firebaseProvider.initialize({
        'projectId': AppConfig.projectId,
        'apiKey': AppConfig.apiKey,
      });

      // Register provider
      DSAuthManager.registerProvider('firebase', firebaseProvider, metadata);

      // Create auth manager
      _authManager = DSAuthManager('firebase');

      // Enable debugging if needed
      DSAuthManager.enableDebugging = AppConfig.enableDebugLogging;

      // Initialize core last
      await _core?.initialize(
        config: {
          'auth': {'provider': firebaseProvider, 'manager': _authManager},
          'sessionTimeout': AppConfig.sessionTimeout.inSeconds,
          'debug': AppConfig.enableDebugLogging,
        },
        context: context,
      );

      if (mounted) {
        setState(() {
          _initialized = true;
          _error = null;
        });
      }
    } catch (e, stackTrace) {
      debugPrint('Initialization Error: $e');
      debugPrint('StackTrace: $stackTrace');
      if (mounted) {
        setState(() {
          _error = e.toString();
          _initialized = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: _error != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Error: $_error',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _error = null;
                            _initialized = false;
                          });
                          _initializeDartStream(context);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Initializing DartStream...'),
                    ],
                  ),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DartStream Auth Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: AuthDemo(authManager: _authManager!),
    );
  }

  @override
  void dispose() {
    if (_initialized) {
      _core?.dispose();
    }
    super.dispose();
  }
}
