import 'package:dart_admin_auth_test_app/shared/shared.dart';
import 'package:dart_admin_auth_test_app/utils/extensions.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
