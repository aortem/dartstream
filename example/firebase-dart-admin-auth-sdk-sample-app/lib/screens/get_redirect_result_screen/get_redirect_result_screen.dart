import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';

class GetRedirectResultScreen extends StatelessWidget {
  const GetRedirectResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Redirect Result'),
      ),
      body: Center(
        child: Button(
          onTap: () async {
            try {
              UserCredential? result =
                  await FirebaseApp.firebaseAuth?.getRedirectResult();
              if (result != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Redirect result: ${result.user.uid}')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No redirect result')),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${e.toString()}')),
              );
            }
          },
          title: 'Get Redirect Result',
        ),
      ),
    );
  }
}
