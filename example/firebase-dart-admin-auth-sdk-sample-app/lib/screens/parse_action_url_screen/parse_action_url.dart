import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../shared/button.dart';
import '../../shared/input_field.dart';

class ParseActionUrl extends StatefulWidget {
  const ParseActionUrl({super.key});

  @override
  State<ParseActionUrl> createState() => _ParseActionUrlState();
}

class _ParseActionUrlState extends State<ParseActionUrl> {
  final TextEditingController parseActionUrlController =
      TextEditingController();
  Map<String, String>? parseUrlResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InputField(
                controller: parseActionUrlController,
                label: 'Parse Link',
                hint: '',
              ),
              const SizedBox(height: 20),
              Button(
                onTap: () async {
                  String actionCodeUrl = parseActionUrlController.text;

                  parseUrlResult = await FirebaseApp.firebaseAuth
                      ?.parseActionCodeUrl(actionCodeUrl);

                  if (parseUrlResult != null) {
                    if (kDebugMode) {
                      print(" Mode: ${parseUrlResult!['mode']}");
                      print("OobCode: ${parseUrlResult!['oobCode']}");
                      print("  ContinueUrl: ${parseUrlResult!['continueUrl']}");
                      print(" Lang: ${parseUrlResult!['lang']}");
                    }
                  } else {
                    if (kDebugMode) {
                      print("  Invalid action code URL.");
                    }
                  }

                  setState(() {}); // Refresh the UI
                },
                title: 'Submit',
              ),
              const SizedBox(height: 20),
              parseUrlResult == null
                  ? const SizedBox()
                  : Column(
                      children: [
                        Row(
                          children: [
                            const Text('code: '),
                            Text(parseUrlResult!['code'] ?? 'N/A'),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('apiKey: '),
                            Text(parseUrlResult!['apiKey'] ?? 'N/A'),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('mode: '),
                            Text(parseUrlResult!['mode'] ?? 'N/A'),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('continueUrl: '),
                            Text(parseUrlResult!['continueUrl'] ?? 'N/A'),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('languageCode: '),
                            Text(parseUrlResult!['languageCode'] ?? 'N/A'),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('clientId: '),
                            Text(parseUrlResult!['clientId'] ?? 'N/A'),
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
