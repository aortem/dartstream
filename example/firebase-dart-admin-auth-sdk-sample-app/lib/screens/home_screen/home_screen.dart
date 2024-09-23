

import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/sign_up_screen/sign_up_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/utils/extensions.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
<<<<<<< HEAD
=======
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
>>>>>>> c941e16 (testing on issues 36 to 41)
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
              onTap: () {

              },
              title: "Update Current User",
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
              onTap: () async{
                try {
                  await FirebaseApp.firebaseAuth?.signOut();
                    final firebaseApp = FirebaseApp.instance;
                  final currentUser = firebaseApp.getCurrentUser();

                  if (currentUser == null) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ));
                    BotToast.showText(text: 'User is signOut');
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
              onTap: () async{
                // await FirebaseApp.firebaseAuth
                //     ?.firebasePhoneNumberLinkMethod("+92 3006205990");
              },
              title: "Link Phone number",
            ),
            10.vSpace,
            ActionTile(
              onTap: () async{
                await FirebaseApp.firebaseAuth
                    ?.deleteFirebaseUser(UserIdToken);
                final firebaseApp = FirebaseApp.instance;
                final currentUser = firebaseApp.getCurrentUser();

                if (currentUser == null) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SignUpScreen(),
                  ));
                  BotToast.showText(text: 'User is signOut');
                } else {
                  log('No user is currently signed in.');
                }
                // final firebaseApp = FirebaseApp.instance;
                // final currentUser = firebaseApp.getCurrentUser();
                //
                // if (currentUser == null) {
                //   Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => const SignUpScreen(),
                //   ));
                //   BotToast.showText(text: 'User is signOut');
                // } else {
                //   log('No user is currently signed in.');
                // }

              },
              title: "delete user",
            ),
            10.vSpace,
            ActionTile(
              onTap: () async{
                var tokenId=
                await FirebaseApp.firebaseAuth
                    ?.getIdToken();
                setState(() {
                  UserIdToken=tokenId;
                });
                log("token is $tokenId");
              },
              title: "Get id  token ",
            ),
            10.vSpace,
            ActionTile(
              onTap: () async{
                var tokenId=
                await FirebaseApp.firebaseAuth
                    ?.getIdTokenResult();

                log("token result  $tokenId");
              },
              title: "Get id  token result ",
            ),
            10.vSpace,
            ActionTile(
              onTap: () async{
                var tokenId=
                await FirebaseApp.firebaseAuth
                    ?.parseActionCodeUrl("https://firebase.google.com/docs/reference/js/auth.md#parseactioncodeurl_51293c3");

                log("token result  $tokenId");
              },
              title: "Parse Action Code Url ",
            ),
            10.vSpace, ActionTile(
              onTap: () async{
                // var tokenId=
                // await FirebaseApp.firebaseAuth
                //     ?.updateCurrentUser(User(email: "ubabar@gmail.com",uid: FirebaseAuth.a));

                // log("token result  $tokenId");
              },
              title: "device Langiage",
            ),
            10.vSpace,
            ActionTile(
              onTap: () async{
                // var tokenId=
                // await FirebaseApp.firebaseAuth
                //     ?.updateCurrentUser(User(email: "ubabar@gmail.com",uid: FirebaseAuth.a));

                // log("token result  $tokenId");
              },
              title: "device Langiage",
            ),
            10.vSpace,
          ],
        ),
      ),
    );
  }
}
