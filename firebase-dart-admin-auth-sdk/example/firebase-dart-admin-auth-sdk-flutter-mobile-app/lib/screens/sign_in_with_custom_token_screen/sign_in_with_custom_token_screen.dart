import 'dart:math';
import 'package:firebase/shared/shared.dart';
import 'package:firebase/screens/home_screen/home_screen.dart';
import 'package:firebase/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sign_in_with_custom_token_view_model.dart';

class SignInWithCustomTokenScreen extends StatefulWidget {
  const SignInWithCustomTokenScreen({super.key});

  @override
  State<SignInWithCustomTokenScreen> createState() =>
      _SignInWithCustomTokenScreenState();
}

class _SignInWithCustomTokenScreenState
    extends State<SignInWithCustomTokenScreen> {
  final TextEditingController _uidController = TextEditingController();
  bool _useCustomUid = false;

  @override
  void initState() {
    super.initState();
    _uidController.text = _generateRandomUid();
  }

  String _generateRandomUid() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(10000).toString().padLeft(4, '0');
    return 'user_${timestamp}_$random';
  }

  @override
  void dispose() {
    _uidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignInWithCustomTokenViewModel(),
      child: Consumer<SignInWithCustomTokenViewModel>(
        builder: (context, value, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Sign In with Custom Token'),
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: 20.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SwitchListTile(
                    title: const Text('Use Custom UID'),
                    subtitle: Text(_useCustomUid
                        ? 'Enter your own UID'
                        : 'Using auto-generated UID'),
                    value: _useCustomUid,
                    onChanged: value.loading
                        ? null
                        : (val) {
                            setState(() {
                              _useCustomUid = val;
                              if (!val) {
                                _uidController.text = _generateRandomUid();
                              }
                            });
                          },
                  ),
                  20.vSpace,
                  InputField(
                    controller: _uidController,
                    hint: 'Enter UID or use auto-generated',
                    label: 'UID',
                  ),
                  if (!_useCustomUid) ...[
                    10.vSpace,
                    Button(
                      onTap: value.loading
                          ? () {}
                          : () {
                              setState(() {
                                _uidController.text = _generateRandomUid();
                              });
                            },
                      title: 'Generate New UID',
                    ),
                  ],
                  20.vSpace,
                  Button(
                    onTap: value.loading
                        ? () {}
                        : () {
                            value.signInWithCustomToken(
                              _uidController.text,
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              ),
                            );
                          },
                    title: 'Sign In with Custom Token',
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
