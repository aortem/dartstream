import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/apply_action_code_screen/apply_action_code_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/home_screen/home_screen_view_model.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/set_language_code_screen/set_language_code_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/unlink_provider_screen/unlink_provider_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/update_password_screen/update_password_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    final firebaseApp = FirebaseApp.instance;
    final currentUser = firebaseApp.getCurrentUser();

    if (currentUser != null) {
      // Log user details
      log('User ID: ${currentUser.uid}');
      log('Email: ${currentUser.email}');
      log('Email Verified: ${currentUser.emailVerified}');
      log('Phone Number: ${currentUser.phoneNumber}');
      log('Display Name: ${currentUser.displayName}');
      log('Photo URL: ${currentUser.photoURL}');
    } else {
      log('No user is currently signed in.');
    }

    // TODO: implement initState
    super.initState();
  }

  var UserIdToken;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeScreenViewModel(),
      child: Consumer<HomeScreenViewModel>(
        builder: (context, value, child) => Scaffold(
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
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const UpdatePasswordScreen(),
                    ),
                  ),
                  title: "Update Password",
                ),
                10.vSpace,
                ActionTile(
                  loading: value.verificationLoading,
                  onTap: () => value.sendEmailVerificationCode(
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ApplyActionCodeScreen(),
                        ),
                      );
                    },
                  ),
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
                ActionTile(
                  loading: value.loading,
                  onTap: () => value.reloadUser(),
                  title: "Reload User",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SetLanguageCodeScreen(),
                    ),
                  ),
                  title: "Set Language Code",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const UnlinkProviderScreen(),
                    ),
                  ),
                  title: "Unlink Provider",
                ),
                10.vSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
