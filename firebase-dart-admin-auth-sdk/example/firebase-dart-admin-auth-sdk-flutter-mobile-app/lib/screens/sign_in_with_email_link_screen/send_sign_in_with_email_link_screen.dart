import 'package:firebase/screens/home_screen/home_screen.dart';
import 'package:firebase/screens/sign_in_with_email_link_screen/send_sign_in_with_email_link_screen_view_model.dart';
import 'package:firebase/shared/shared.dart';
import 'package:firebase/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendSignInWithEmailLinkScreen extends StatefulWidget {
  const SendSignInWithEmailLinkScreen({super.key});

  @override
  State<SendSignInWithEmailLinkScreen> createState() =>
      _SendSignInWithEmailLinkScreenState();
}

class _SendSignInWithEmailLinkScreenState
    extends State<SendSignInWithEmailLinkScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SendSignInWithEmailLinkScreenViewModel(),
      child: Consumer<SendSignInWithEmailLinkScreenViewModel>(
        builder: (context, value, child) => Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: 20.horizontal,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InputField(
                    controller: _emailController,
                    label: 'Email',
                    hint: '',
                  ),
                  20.vSpace,
                  Button(
                    onTap: () =>
                        value.sendSignInLinkToEmail(_emailController.text),
                    title: 'Send Sign In Link',
                    loading: value.loading,
                  ),
                  30.vSpace,
                  const Divider(),
                  30.vSpace,
                  InputField(
                    controller: _linkController,
                    label: 'Sign-in Link',
                    hint: 'Paste the sign-in link here',
                  ),
                  20.vSpace,
                  Button(
                    onTap: () => value.signInWithEmailLink(
                      _emailController.text,
                      _linkController.text,
                      () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      ),
                    ),
                    title: 'Sign In with Email Link',
                    loading: value.signingIn,
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
