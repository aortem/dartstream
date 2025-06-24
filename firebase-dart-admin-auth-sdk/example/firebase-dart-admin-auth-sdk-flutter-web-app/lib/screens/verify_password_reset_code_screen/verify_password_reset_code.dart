import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase/utils/extensions.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:flutter/material.dart';

import '../../shared/button.dart';
import '../../shared/input_field.dart';

class VerifyPasswordResetCode extends StatelessWidget {
  VerifyPasswordResetCode({super.key});

  final TextEditingController verifyPasswordRestController =
      TextEditingController();

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
                label: 'Code',
                hint: '',
              ),
              20.vSpace,
              Button(
                onTap: () async {
                  try {
                    // Attempt to verify the password reset code
                    var email = await FirebaseApp.firebaseAuth
                        ?.verifyPasswordResetCode(
                          verifyPasswordRestController.text,
                        );

                    if (email != null) {
                      BotToast.showText(
                        text: "Password reset code verified. Email: $email",
                      );

                      log("Password reset code verified. Email: $email");
                      // Proceed with your logic, e.g., redirecting to reset password screen
                    }
                  } catch (e) {
                    BotToast.showText(text: e.toString());
                    // Log the error if verification fails
                    log("Error verifying password reset code: $e");
                    // Optionally show an error message to the user
                  }
                },
                title: 'Verify Code',
              ),
              20.vSpace,
            ],
          ),
        ),
      ),
    );
  }
}
