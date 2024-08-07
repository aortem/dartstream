import 'package:firebase_dart_admin_auth_sdk_sample_app/utils/extensions.dart';
import 'package:flutter/material.dart';

import '../../shared/button.dart';
import '../../shared/input_field.dart';

class VerifyPasswordResetCode extends StatelessWidget {
   VerifyPasswordResetCode({super.key});

  final TextEditingController verifyPasswordRestController = TextEditingController();


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
              controller: verifyPasswordRestController,
              label: 'Email ',
              hint: '',
            ),
            20.vSpace,
            Button(
              onTap: () async {


              }
              ,

              title: 'Sign In',
            ),
            20.vSpace,

          ],
        ),
      ),
    ),
  );
}
}
