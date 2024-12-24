import 'package:firebase/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/shared.dart';
import 'package:firebase/utils/extensions.dart';
import 'gcp_sign_in_view_model.dart';

class GCPSignInScreen extends StatefulWidget {
  const GCPSignInScreen({super.key});

  @override
  State<GCPSignInScreen> createState() => _GCPSignInScreenState();
}

class _GCPSignInScreenState extends State<GCPSignInScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GCPSignInViewModel(),
      child: Consumer<GCPSignInViewModel>(
        builder: (context, value, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Sign In with GCP'),
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: 20.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  20.vSpace,
                  const Text(
                    'Sign in with your Google Account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  20.vSpace,
                  Button(
                    onTap: () => value.signIn(
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      ),
                    ),
                    title: 'Sign in with Google',
                    loading: value.loading,
                  ),
                  20.vSpace,
                  GestureDetector(
                    onTap: () => showSignMethodsBottomSheet(context),
                    child: const Text(
                      'Explore more sign in options',
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
