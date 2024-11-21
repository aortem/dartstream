<<<<<<< HEAD
import 'package:firebase/screens/home_screen/home_screen.dart';
=======
>>>>>>> e2ce3d1eb951f7d2f64ea007f4425e46b810cc68
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sign_in_with_credential_view_model.dart';

class SignInWithCredential extends StatelessWidget {
  const SignInWithCredential({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignInWithCredentialViewModel(),
      child: Consumer<SignInWithCredentialViewModel>(
<<<<<<< HEAD
        builder: (context, value, child) => Scaffold(
          body: Column(
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
              ElevatedButton(
                  onPressed: () {
                    value.loginWithFacebook(context);
                  },
                  child: const Text("Sign In With Facebook"))
            ],
            // chil
            //d: Builder(
            //   builder: (context) {
            //     if (Platform.isIOS) {
            //       return Button(
            //         onTap: () {},
            //         title: 'Sign In With Apple',
            //       );
            //     }
            //     return Button(
            //       onTap: () => value.signInWithCredential(
            //         () => Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => const HomeScreen(),
            //           ),
            //         ),
            //       ),
            //       title: 'Sign In With Google',
            //     );
            //   },
            // ),
=======
        builder: (context, viewModel, child) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (kIsWeb)
                  Column(
                    children: [
                      Button(
                        onTap: () => viewModel.signInWithCredential(
                          'google.com',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          ),
                        ),
                        title: 'Sign In With Google',
                      ),
                      const SizedBox(height: 20),
                      Button(
                        onTap: () => viewModel.signInWithCredential(
                          'apple.com',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          ),
                        ),
                        title: 'Sign In With Apple',
                      ),
                    ],
                  )
                else if (!kIsWeb && Platform.isIOS)
                  Button(
                    onTap: () => viewModel.signInWithCredential(
                      'apple.com',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      ),
                    ),
                    title: 'Sign In With Apple',
                  )
                else
                  Button(
                    onTap: () => viewModel.signInWithCredential(
                      'google.com',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      ),
                    ),
                    title: 'Sign In With Google',
                  ),
                const SizedBox(height: 20),
              ],
            ),
>>>>>>> e2ce3d1eb951f7d2f64ea007f4425e46b810cc68
          ),
        ),
      ),
    );
  }
}
