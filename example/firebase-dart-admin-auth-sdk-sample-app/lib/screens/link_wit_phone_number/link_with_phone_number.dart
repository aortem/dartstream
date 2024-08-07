import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/utils/extensions.dart';
import 'package:flutter/material.dart';

import '../../shared/button.dart';
import '../../shared/input_field.dart';

class LinkPhoneNumberScreen extends StatefulWidget {
  const LinkPhoneNumberScreen({super.key});

  @override
  State<LinkPhoneNumberScreen> createState() => _LinkPhoneNumberScreenState();
}

class _LinkPhoneNumberScreenState extends State<LinkPhoneNumberScreen> {
  final TextEditingController phoneLinkController = TextEditingController();

  @override
  void dispose() {
    phoneLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: 20.horizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InputField(
                controller: phoneLinkController,
                label: 'Phone number Link',
                hint: '',
              ),
              20.vSpace,
              Button(
                onTap: () async {
                  await FirebaseApp.firebaseAuth
                      ?.firebasePhoneNumberLinkMethod(phoneLinkController.text);
                },
                title: 'Send',
              ),
              20.vSpace,
            ],
          ),
        ),
      ),
    );
  }
}
