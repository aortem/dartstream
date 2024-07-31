import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:provider/provider.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/initialize_recaptcha_config_screen/initialize_recaptcha_config_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/get_redirect_result_screen/get_redirect_result_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/get_multi_factor_resolver_screen/get_multi_factor_resolver_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/fetch_sign_in_methods_for_email_screen/fetch_sign_in_methods_for_email_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _currentIdToken;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _setupStreams();
  }

  void _setupStreams() {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    auth.onIdTokenChanged().listen((User? user) {
      setState(() {
        _currentUser = user;
        _currentIdToken = user?.getIdToken() as String?;
      });
      print('ID Token changed: ${user?.getIdToken()}');
    });

    auth.onAuthStateChanged().listen((User? user) {
      print('Auth State changed: ${user?.uid}');
    });
  }

  Future<void> _revokeToken() async {
    if (_currentIdToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No token available to revoke')),
      );
      return;
    }

    try {
      final auth = Provider.of<FirebaseAuth>(context, listen: false);
      await auth.revokeToken(_currentIdToken!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token revoked successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to revoke token: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Test App',
        ),
      ),
      body: SingleChildScrollView(
        padding: 20.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Current User: ${_currentUser?.uid ?? 'None'}'),
            10.vSpace,
            ActionTile(
              onTap: _revokeToken,
              title: "Revoke Current Token",
            ),
            10.vSpace,
            ActionTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InitializeRecaptchaConfigScreen()),
                );
              },
              title: "Initialize reCAPTCHA Config",
            ),
            10.vSpace,
            ActionTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GetRedirectResultScreen()),
                );
              },
              title: "Get Redirect Result",
            ),
            10.vSpace,
            ActionTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GetMultiFactorResolverScreen()),
                );
              },
              title: "Get Multi-Factor Resolver",
            ),
            10.vSpace,
            ActionTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FetchSignInMethodsForEmailScreen()),
                );
              },
              title: "Fetch Sign-In Methods for Email",
            ),
            10.vSpace,
            ActionTile(
              onTap: () {},
              title: "Verify Before Update Email",
            ),
            10.vSpace,
            ActionTile(
              onTap: () {},
              title: "Update Profile",
            ),
            10.vSpace,
            ActionTile(
              onTap: () {},
              title: "Update Password",
            ),
            10.vSpace,
            ActionTile(
              onTap: () {},
              title: "Send Verification Email",
            ),
            10.vSpace,
            ActionTile(
              onTap: () {},
              title: "Send Password Reset Email",
            ),
            10.vSpace,
            ActionTile(
              onTap: () {},
              title: "Sign Out",
            ),
            10.vSpace,
          ],
        ),
      ),
    );
  }
}
