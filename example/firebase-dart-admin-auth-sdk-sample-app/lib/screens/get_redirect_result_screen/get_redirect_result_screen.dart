import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';

class GetRedirectResultScreen extends StatefulWidget {
  const GetRedirectResultScreen({Key? key}) : super(key: key);

  @override
  _GetRedirectResultScreenState createState() =>
      _GetRedirectResultScreenState();
}

class _GetRedirectResultScreenState extends State<GetRedirectResultScreen> {
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Redirect Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Button(
              onTap: () async {
                try {
                  UserCredential? result =
                      await FirebaseApp.firebaseAuth?.getRedirectResult();
                  setState(() {
                    if (result != null) {
                      _result = 'Redirect result: ${result.user.uid}';
                    } else {
                      _result = 'No redirect result';
                    }
                  });
                } catch (e) {
                  setState(() {
                    _result = 'Error: ${e.toString()}';
                  });
                }
              },
              title: 'Get Redirect Result',
            ),
            SizedBox(height: 20),
            Text(_result, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
