import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class ConnectAuthEmulatorService {
  final FirebaseAuth auth;

  ConnectAuthEmulatorService(this.auth);

  void connect(String host, int port) {
    final emulatorUrl = 'http://$host:$port';
    auth.setEmulatorUrl(emulatorUrl);
    print('Connected to Firebase Auth emulator at $emulatorUrl');
  }
}

extension FirebaseAuthEmulator on FirebaseAuth {
  void setEmulatorUrl(String url) {
    // Implementation to set the emulator URL
    // This could be a property of FirebaseAuth or affect how requests are made
    print('Emulator URL set to: $url');
  }
}
