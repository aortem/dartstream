import 'package:firebase/screens/home_screen/home_screen.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'sign_in_with_credential_view_model.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class SignInWithCredential extends StatelessWidget {
  const SignInWithCredential({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignInWithCredentialViewModel(),
      child: Consumer<SignInWithCredentialViewModel>(
        builder: (context, value, child) => Scaffold(
          body: SizedBox(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      value.signInWithCredential(
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        ),
                      );
                    },
                    child: const Text("Sign In With Google")),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      value.loginWithFacebook(context);
                    },
                    child: const Text("Sign In With Facebook")),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      value.login(kIsWeb ? true : false, context);
                    },
                    child: const Text("Sign In With Microsoft"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
