import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/apply_action_code_screen/apply_action_code_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/home_screen/home_screen_view_model.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/parse_action_url_screen/parse_action_url.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/set_language_code_screen/set_language_code_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/sign_up_screen/sign_up_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/storage_screen/storage.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/unlink_provider_screen/unlink_provider_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/update_password_screen/update_password_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../link_wit_phone_number/link_with_phone_number.dart';
import '../set_presistence/set_presistance_screen.dart';
import '../update_current_user/update_current_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                ActionTile(
                  onTap: () async {
                    try {
                      await FirebaseApp.firebaseAuth?.signOut();
                      final firebaseApp = FirebaseApp.instance;
                      final currentUser = firebaseApp.getCurrentUser();

                      if (currentUser == null) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ));
                        BotToast.showText(text: 'User is Signout');
                      } else {
                        log('No user is currently signed in.');
                      }
                    } catch (e) {
                      BotToast.showText(text: e.toString());
                    }
                  },
                  title: "Sign Out",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LinkPhoneNumberScreen(),
                      ),
                    );
                  },
                  title: "Link Phone number",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () async {
                    await FirebaseApp.firebaseAuth?.deleteFirebaseUser();
                    final firebaseApp = FirebaseApp.instance;
                    final currentUser = firebaseApp.getCurrentUser();

                    if (currentUser == null) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ));
                      BotToast.showText(text: 'User is signout');
                    } else {
                      log('No user is currently signed in.');
                    }
                  },
                  title: "delete user",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () async {
                    var tokenId = await FirebaseApp.firebaseAuth?.getIdToken();
                    setState(() {
                      UserIdToken = tokenId;
                    });
                    log("token is $tokenId");
                  },
                  title: "Get id  token ",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () async {
                    var tokenId =
                        await FirebaseApp.firebaseAuth?.getIdTokenResult();

                    log("token result  $tokenId");
                  },
                  title: "Get id  token result ",
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
                ActionTile(
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ParseActionUrl(),
                    ));
                  },
                  title: "Parse Action Code Url ",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UpdateUserScreen(),
                      ),
                    );
                  },
                  title: "Update Current User",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () async {
                    // var tokenId=
                    FirebaseApp.firebaseAuth?.setLanguageCodeMethod(
                        'en', 'firebasdartadminauthsdk');

                    // log("token result  $tokenId");
                  },
                  title: "setdevice Language",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () async {
                    // var tokenId=
                    FirebaseApp.firebaseAuth
                        ?.getLanguageCodeMethod('firebasdartadminauthsdk');

                    // log("token result  $tokenId");
                  },
                  title: "get device Language",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () async {
                    // var tokenId=
                    FirebaseApp.firebaseAuth?.getAuthBeforeChange();

                    // log("token result  $tokenId");
                  },
                  title: "before auth state change",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const PersistenceSelectorDropdown(),
                      ),
                    );
                  },
                  title: " Set Presistance",
                ),
                10.vSpace,
                10.vSpace,
                ActionTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const StorageExample(),
                    ),
                  ),
                  title: "Storage",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
