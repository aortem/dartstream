import 'package:flutter/material.dart';

class OAuthSelectionScreen extends StatelessWidget {
  const OAuthSelectionScreen({super.key});

  void _selectProvider(BuildContext context, String providerUrl) async {
    //final auth = FirebaseApp.firebaseAuth;
    // await auth?.signInWithRedirect(providerUrl);
    // try {
    //   final userInfo = await auth?.signInWithRedirectResult(providerUrl);
    //   print('User info: $userInfo');
    // } catch (e) {
    //   print('Error: $e');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select OAuth Provider')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Select OAuth Provider'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('Google'),
                        onTap: () {
                          Navigator.of(context).pop();
                          _selectProvider(context,
                              'https://accounts.google.com/o/oauth2/auth');
                        },
                      ),
                      ListTile(
                        title: const Text('Facebook'),
                        onTap: () {
                          Navigator.of(context).pop();
                          _selectProvider(context,
                              'https://www.facebook.com/v10.0/dialog/oauth');
                        },
                      ),
                      ListTile(
                        title: const Text('Provider X'),
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
          child: const Text('Sign In'),
        ),
      ),
    );
  }
}
