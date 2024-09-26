import 'dart:developer';

import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/utils/extensions.dart';
import 'package:flutter/material.dart';

import '../../shared/button.dart';
import '../../shared/input_field.dart';

class ParseActionUrl extends StatefulWidget {
  const ParseActionUrl({super.key});

  @override
  State<ParseActionUrl> createState() => _ParseActionUrlState();
}

class _ParseActionUrlState extends State<ParseActionUrl> {
  final TextEditingController _parseActionUrlController =
      TextEditingController();

  Map<String, dynamic>? parseUrlresult;

  @override
  void dispose() {
    _parseActionUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: 20.horizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InputField(
                controller: _parseActionUrlController,
                label: 'Parse Link',
                hint: '',
              ),
              20.vSpace,
              Button(
                onTap: () async {
                  String actionCodeUrl =
                      "https://example.com/finishSignUp?mode=resetPassword&oobCode=abc123&continueUrl=https://example.com/home&lang=en";

                  Map<String, String>? parsedData = await FirebaseApp
                      .firebaseAuth
                      ?.parseActionCodeUrl(actionCodeUrl);

                  if (parsedData != null) {
                    log("Mode: ${parsedData['mode']}");
                    log("OobCode: ${parsedData['oobCode']}");
                    log("ContinueUrl: ${parsedData['continueUrl']}");
                    log("Lang: ${parsedData['lang']}");
                  } else {
                    log("Invalid action code URL.");
                  }
                  var parseUrlresult = await FirebaseApp.firebaseAuth
                      ?.parseActionCodeUrl(_parseActionUrlController.text);

                  log("Parse Action Code Url   $parseUrlresult");
                  //    log("Parse Action Code Url   ${parseUrlresult?['code']}");
                },
                title: 'Submit',
              ),
              20.vSpace,
              parseUrlresult == null
                  ? const SizedBox()
                  : Column(
                      children: [
                        Row(
                          children: [
                            const Text('code'),
                            Text(parseUrlresult?['code'])
                          ],
                        ),
                        Row(
                          children: [
                            const Text('apiKey'),
                            Text(parseUrlresult?['apiKey'])
                          ],
                        ),
                        Row(
                          children: [
                            const Text('mode'),
                            Text(parseUrlresult?['mode'])
                          ],
                        ),
                        Row(
                          children: [
                            const Text('continueUrl'),
                            Text(parseUrlresult?['continueUrl'])
                          ],
                        ),
                        Row(
                          children: [
                            const Text('languageCode'),
                            Text(parseUrlresult?['languageCode'])
                            const Text('languageCode'),
                            Text(parseUrlresult['languageCode'])
                          ],
                        ),
                        Row(
                          children: [
                            const Text('clientId'),
                            Text(parseUrlresult?['clientId'])
                          ],
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
