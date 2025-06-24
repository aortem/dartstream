// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, implementation_imports
import 'dart:async';
import 'dart:developer';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase/screens/link_with_credientials/link_with_credientials.dart';
import 'package:firebase/screens/verify_password_reset_code_screen/verify_password_reset_code.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase/screens/apply_action_code_screen/apply_action_code_screen.dart';
import 'package:firebase/screens/home_screen/home_screen_view_model.dart';
import 'package:firebase/screens/parse_action_url_screen/parse_action_url.dart';
import 'package:firebase/screens/set_language_code_screen/set_language_code_screen.dart';
import 'package:firebase/screens/sign_up_screen/sign_up_screen.dart';
import 'package:firebase/screens/storage_screen/storage.dart';
import 'package:firebase/screens/unlink_provider_screen/unlink_provider_screen.dart';
import 'package:firebase/screens/update_password_screen/update_password_screen.dart';
import 'package:firebase/screens/update_profile_screen/update_profile_screen.dart';
import 'package:firebase/screens/verify_before_email_update_screen/verify_before_email_update_screen.dart';
import 'package:firebase/shared/shared.dart';
import 'package:firebase/utils/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/auth_state_changed.dart'
    as auth_state;
import 'package:firebase_dart_admin_auth_sdk/src/auth/id_token_changed.dart'
    as id_token;

import '../link_wit_phone_number/link_with_phone_number.dart';
import '../update_current_user/update_current_user.dart';
import 'package:firebase/screens/get_redirect_result_screen/get_redirect_result_screen.dart';
import 'package:firebase/screens/initialize_recaptcha_config_screen/initialize_recaptcha_config_screen.dart';
import 'package:firebase/screens/multi_factor_resolver_screen/multi_factor_resolver_screen.dart';
import 'package:firebase/screens/password_reset_screen/password_reset_screen.dart';
import 'package:firebase/screens/fetch_sign_in_methods_for_email_screen/fetch_sign_in_methods_screen.dart';
import 'package:firebase/screens/create_user_screen/create_user_screen.dart';
import 'package:firebase/screens/confirm_password_reset_screen/confirm_password_reset_screen.dart';
import 'package:firebase/screens/check_action_code_screen/check_action_code_screen.dart';
import 'package:firebase/screens/is_sign_in_with_email_link_screen/is_sign_in_with_email_link_screen.dart';
import 'package:firebase/screens/revoke_token_screen/revoke_token_screen.dart';
import 'package:firebase/screens/on_Id_Token_Changed/on_id_token_changed.dart';
import 'package:firebase/screens/auth_state_test_screen/auth_state_test_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic userIdToken;
  User? _currentUser;
  bool _isConnectedToEmulator = false;
  late auth_state.Unsubscribe _authStateUnsubscribe;
  late id_token.Unsubscribe _idTokenUnsubscribe;

  dynamic UserIdToken;

  @override
  void initState() {
    super.initState();
    _setupAuthListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCurrentIdToken();
    });
  }

  void _setupAuthListeners() {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);

    // Subscribe to ID token changes
    StreamSubscription<User?>? idTokenSubscription;
    idTokenSubscription = auth.onIdTokenChanged().listen(
      (User? user) async {
        final idToken = user != null ? await user.getIdToken() : null;
        setState(() {
          _currentUser = user;
        });
        if (kDebugMode) {
          print('ID Token changed: $idToken');
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('ID Token change error: $error');
        }
      },
    );

    // Subscribe to auth state changes
    StreamSubscription<User?>? authStateSubscription;
    authStateSubscription = auth.onAuthStateChanged().listen(
      (User? user) {
        setState(() {
          _currentUser = user;
        });
        if (kDebugMode) {
          print('Auth State changed: ${user?.uid}');
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('Auth State change error: $error');
        }
      },
    );

    // Store subscriptions for cleanup
    _authStateUnsubscribe = () {
      authStateSubscription?.cancel();
    };

    _idTokenUnsubscribe = () {
      idTokenSubscription?.cancel();
    };
  }

  @override
  void dispose() {
    _authStateUnsubscribe();
    _idTokenUnsubscribe();
    super.dispose();
  }

  Future<void> _fetchCurrentIdToken() async {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    final user = auth.currentUser;
    setState(() {
      _currentUser = user;
      if (user != null) {
        user
            .getIdToken(true)
            .then((idToken) {
              setState(() {});
            })
            .catchError((error) {
              if (kDebugMode) {
                print("Error fetching token: $error");
              }
            });
      } else {}
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchCurrentIdToken();
  }

  void _connectToEmulator() {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    auth.connectAuthEmulator('localhost', 9099);
    setState(() {
      _isConnectedToEmulator = true;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Connected to Auth Emulator')));
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    return ChangeNotifierProvider(
      create: (context) => HomeScreenViewModel(),
      child: Consumer<HomeScreenViewModel>(
        builder: (context, value, child) => Scaffold(
          appBar: AppBar(
            leading: Text(value.displayName),
            title: const Text('Test App'),
            actions: [
              if (value.displayImage != null && value.displayImage!.isNotEmpty)
                Text(value.displayImage.toString()),
              Text("No of linked providers ${value.numberOfLinkedProviders}"),
            ],
          ),
          body: SingleChildScrollView(
            padding: 20.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Current User: ${_currentUser?.uid ?? 'None'}'),
                10.vSpace,
                ActionTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VerifyBeforeEmailUpdate(),
                    ),
                  ),
                  title: "Verify Before Update Email",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UpdateProfileScreen(),
                      ),
                    );
                    value.setLoading(false);
                  },
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
                  onTap: () => value.sendEmailVerificationCode(() {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ApplyActionCodeScreen(),
                      ),
                    );
                  }),
                  title: "Send Verification Email",
                ),
                10.vSpace,
                ActionTile(onTap: () {}, title: "Send Password Reset Email"),
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
                  onTap: () {
                    try {
                      FirebaseApp.firebaseAuth?.signOut();
                      final firebaseApp = FirebaseApp.instance;
                      final currentUser = firebaseApp.getCurrentUser();

                      if (currentUser == null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
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
                  onTap: () {
                    FirebaseApp.firebaseAuth?.deleteFirebaseUser();
                    final firebaseApp = FirebaseApp.instance;
                    final currentUser = firebaseApp.getCurrentUser();

                    if (currentUser == null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                      BotToast.showText(text: 'User is deleted');
                    } else {
                      log('No user is currently signed in.');
                    }
                  },
                  title: "Delete User",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LinkWithCredentials(),
                      ),
                    );
                  },
                  title: "Link with credientials",
                ),
                //LinkWIthCredientials
                10.vSpace,
                ActionTile(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerifyPasswordResetCode(),
                      ),
                    );
                  },
                  title: "Verify Password Reset Code",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () async {
                    var tokenId = await FirebaseApp.firebaseAuth?.getIdToken();
                    setState(() {
                      userIdToken = tokenId!;
                    });
                    if (kDebugMode) {
                      print("token result  $tokenId");
                    }
                  },
                  title: "Get id token",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () async {
                    var tokenId = await FirebaseApp.firebaseAuth
                        ?.getIdTokenResult();

                    if (kDebugMode) {
                      print("token result  $tokenId");
                    }
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ParseActionUrl(),
                      ),
                    );
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
                      'en',
                      'firebasdartadminauthsdk',
                    );

                    // log("token result  $tokenId");
                  },
                  title: "setdevice Language",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () async => value.getAdditionalUserInfo(),
                  loading: value.getAdditionalInfoLoading,
                  title: "Get Additional User Info",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () async => value.linkProvider(),
                  loading: value.linkProviderLoading,
                  title: "Link Provider to User",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () async {
                    // var tokenId=
                    FirebaseApp.firebaseAuth?.getLanguageCodeMethod(
                      'firebasdartadminauthsdk',
                    );

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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FetchSignInMethodsScreen(),
                      ),
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
                        builder: (context) => const CreateUserScreen(),
                      ),
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
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RevokeAccessTokenScreen(),
                      ),
                    );
                  },
                  title: "Revoke Access token",
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
                      builder: (context) => IdTokenChangedScreen(auth: auth),
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
                      builder: (context) => const PasswordResetScreen(),
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
                ActionTile(
                  onTap: () async => value.getAdditionalUserInfo(),
                  loading: value.getAdditionalInfoLoading,
                  title: "Get Additional User Info",
                ),
                10.vSpace,
                ActionTile(
                  onTap: () async => value.linkProvider(),
                  loading: value.linkProviderLoading,
                  title: "Link Provider to User",
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
