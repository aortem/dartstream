// connect_auth_emulator_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';

class ConnectAuthEmulatorScreen extends StatefulWidget {
  @override
  _ConnectAuthEmulatorScreenState createState() =>
      _ConnectAuthEmulatorScreenState();
}

class _ConnectAuthEmulatorScreenState extends State<ConnectAuthEmulatorScreen> {
  final TextEditingController _hostController =
      TextEditingController(text: 'localhost');
  final TextEditingController _portController =
      TextEditingController(text: '9099');
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Auth Emulator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputField(
              controller: _hostController,
              hint: 'Enter host',
              label: 'Host',
            ),
            SizedBox(height: 10),
            InputField(
              controller: _portController,
              hint: 'Enter port',
              label: 'Port',
            ),
            SizedBox(height: 20),
            Button(
              onTap: () {
                try {
                  FirebaseAuth(
                          apiKey: 'your_api_key', projectId: 'your_project_id')
                      .connectAuthEmulator(
                    _hostController.text,
                    int.parse(_portController.text),
                  );
                  setState(() {
                    _result =
                        'Connected to Auth Emulator at ${_hostController.text}:${_portController.text}';
                  });
                } catch (e) {
                  setState(() {
                    _result = 'Error: ${e.toString()}';
                  });
                }
              },
              title: 'Connect to Auth Emulator',
            ),
            SizedBox(height: 20),
            Text(_result, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
