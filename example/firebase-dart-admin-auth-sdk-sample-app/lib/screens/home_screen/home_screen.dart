import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/apply_action_code_screen/apply_action_code_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/home_screen/home_screen_view_model.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/parse_action_url_screen/parse_action_url.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/set_language_code_screen/set_language_code_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/sign_up_screen/sign_up_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/unlink_provider_screen/unlink_provider_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/update_password_screen/update_password_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../link_wit_phone_number/link_with_phone_number.dart';
import '../set_presistence/set_presistance_screen.dart';
import '../update_current_user/update_current_user.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/get_redirect_result_screen/get_redirect_result_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/initialize_recaptcha_config_screen/initialize_recaptcha_config_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/multi_factor_resolver_screen/multi_factor_resolver_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/password_reset_screen/password_reset_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/fetch_sign_in_methods_for_email_screen/fetch_sign_in_methods_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/create_user_screen/create_user_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/confirm_password_reset_screen/confirm_password_reset_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/check_action_code_screen/check_action_code_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/is_sign_in_with_email_link_screen/is_sign_in_with_email_link_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/revoke_token_screen/revoke_token_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/on_Id_Token_Changed/on_Id_Token_Changed.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/auth_state_test_screen/auth_state_test_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var UserIdToken;
  String? _currentIdToken;
  User? _currentUser;
  bool _isConnectedToEmulator = false;

  @override
  void initState() {
    super.initState();
    _setupStreams();
  }

  void _setupStreams() {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    auth.onIdTokenChanged().listen((User? user) async {
      final idToken = user != null ? await user.getIdToken() : null;
      setState(() {
        _currentUser = user;
        _currentIdToken = idToken;
      });
      print('ID Token changed: $idToken');
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
      print('Revoking token: $_currentIdToken');
      await auth.revokeAccessToken;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token revoked successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to revoke token: $e')),
      );
    }
  }

  void _connectToEmulator() {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    auth.connectAuthEmulator('localhost', 9099);
    setState(() {
      _isConnectedToEmulator = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Connected to Auth Emulator')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
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
                Text('Current User: ${_currentUser?.uid ?? 'None'}'),
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
                        BotToast.showText(text: 'User is deleted');
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
                  title: "Delete user",
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
                  title: "Get id token",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () async {
                    var tokenId =
                        await FirebaseApp.firebaseAuth?.getIdTokenResult();
                    log("token result  $tokenId");
                  },
                  title: "Get id token result",
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
                  title: "Parse Action Code Url",
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
                  },
                  title: "Device Language",
                ),
                10.vSpace,
                ActionTile(
                  onTap: _revokeToken,
                  title: "Revoke Access Token",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FetchSignInMethodsScreen()),
                    );
                  },
                  title: "Fetch Sign-In Methods for Email",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const GetRedirectResultScreen(),
                    ),
                  ),
                  title: "Get Redirect Result",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateUserScreen()),
                    );
                  },
                  title: "Create User with Email and Password",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          InitializeRecaptchaConfigScreen(auth: auth),
                    ),
                  ),
                  title: "Initialize reCAPTCHA Config",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const IsSignInWithEmailLinkScreen(),
                    ),
                  ),
                  title: "Is sign in with email link",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MultiFactorResolverScreen(),
                    ),
                  ),
                  title: "Multi factor resolver",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RevokeTokenScreen(auth: auth),
                    ),
                  ),
                  title: "Revoke Current token",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AuthStateTestScreen(auth: auth),
                    ),
                  ),
                  title: "Auth State Changed",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TestScreen(auth: auth),
                    ),
                  ),
                  title: "On id token changed",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CheckActionCodeScreen(),
                    ),
                  ),
                  title: "Check action code",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PasswordResetScreen(),
                    ),
                  ),
                  title: "Send Password Reset Email",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ConfirmPasswordResetScreen(),
                    ),
                  ),
                  title: "Confirm Password Reset",
                ),
                10.vSpace,
                ActionTile(
                  onTap: _connectToEmulator,
                  title: _isConnectedToEmulator
                      ? "Connected to Emulator"
                      : "Connect to Auth Emulator",
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
