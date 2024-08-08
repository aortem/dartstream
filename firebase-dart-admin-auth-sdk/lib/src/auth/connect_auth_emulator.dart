import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class ConnectAuthEmulatorService {
  final FirebaseAuth auth;

  ConnectAuthEmulatorService(this.auth);

  void connect(String host, int port) {
    final url = 'http://$host:$port';
    auth.setEmulatorUrl(url);
    print('Connected to Firebase Auth Emulator at $url');
  }
}
