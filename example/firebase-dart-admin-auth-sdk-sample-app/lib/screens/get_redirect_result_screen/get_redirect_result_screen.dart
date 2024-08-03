import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';
import 'package:provider/provider.dart';

class GetRedirectResultScreen extends StatefulWidget {
  const GetRedirectResultScreen({Key? key}) : super(key: key);

  @override
  _GetRedirectResultScreenState createState() =>
      _GetRedirectResultScreenState();
}

class _GetRedirectResultScreenState extends State<GetRedirectResultScreen> {
  String _result = '';

  Future<void> _getRedirectResult() async {
    try {
      final auth = Provider.of<FirebaseAuth>(context, listen: false);
      UserCredential? result = await auth.getRedirectResult();
      setState(() {
        if (result != null && result.user != null) {
          _result =
              'Redirect result: ${result.user!.uid}, Email: ${result.user!.email}';
        } else {
          _result = 'No redirect result';
        }
      });
    } catch (e) {
      setState(() {
        _result = 'Error: ${e.toString()}';
      });
    }
  }

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
              onTap: _getRedirectResult,
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
