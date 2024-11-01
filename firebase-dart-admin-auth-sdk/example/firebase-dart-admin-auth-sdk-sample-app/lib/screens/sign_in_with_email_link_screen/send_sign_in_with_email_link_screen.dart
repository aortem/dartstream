import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/sign_in_with_email_link_screen/send_sign_in_with_email_link_screen_view_model.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/utils/extensions.dart';
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
  final TextEditingController _emailLinkController = TextEditingController();

  @override
  void dispose() {
    _emailLinkController.dispose();
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
                    controller: _emailLinkController,
                    label: 'Email',
                    hint: '',
                  ),
                  20.vSpace,
                  Button(
                    onTap: () =>
                        value.sendSignInLinkToEmail(_emailLinkController.text),
                    title: 'Send Sign In Link',
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
