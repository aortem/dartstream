import 'package:firebase/screens/set_language_code_screen/set_language_code_screen_view_model.dart';
import 'package:firebase/shared/shared.dart';
import 'package:firebase/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetLanguageCodeScreen extends StatefulWidget {
  const SetLanguageCodeScreen({super.key});

  @override
  State<SetLanguageCodeScreen> createState() => _SetLanguageCodeScreenState();
}

class _SetLanguageCodeScreenState extends State<SetLanguageCodeScreen> {
  final TextEditingController _languageCodeController = TextEditingController();

  @override
  void dispose() {
    _languageCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SetLanguageCodeScreenViewModel(),
      child: Consumer<SetLanguageCodeScreenViewModel>(
        builder: (context, value, child) => Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: 20.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InputField(
                    controller: _languageCodeController,
                    label: 'Language Code',
                  ),
                  20.vSpace,
                  Button(
                    onTap: () => value.setLanguageCode(
                      _languageCodeController.text,
                    ),
                    loading: value.loading,
                    title: 'Set Language Code',
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
