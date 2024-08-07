import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

import 'dart:convert';
import 'dart:developer';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class OAuthSelectionScreen extends StatelessWidget {
  void _selectProvider(BuildContext context, String providerUrl) async {
    final auth = FirebaseApp.firebaseAuth;
    await auth?.signInWithRedirect(providerUrl);
    try {
      final userInfo = await auth?.handleRedirectResult();
      print('User info: $userInfo');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select OAuth Provider')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Select OAuth Provider'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text('Google'),
                        onTap: () {
                          Navigator.of(context).pop();
                          _selectProvider(context,
                              'https://accounts.google.com/o/oauth2/auth');
                        },
                      ),
                      ListTile(
                        title: Text('Facebook'),
                        onTap: () {
                          Navigator.of(context).pop();
                          _selectProvider(context,
                              'https://www.facebook.com/v10.0/dialog/oauth');
                        },
                      ),
                      ListTile(
                        title: Text('Provider X'),
                        onTap: () {
                          Navigator.of(context).pop();
                          _selectProvider(
                              context, 'https://providerx.com/oauth2/auth');
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Text('Sign In'),
        ),
      ),
    );
  }
}
