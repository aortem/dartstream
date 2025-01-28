import 'package:firebase/screens/update_profile_screen/update_profile_screen_view_model.dart';
import 'package:firebase/shared/shared.dart';
import 'package:firebase/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _displayImageController = TextEditingController();

  @override
  void dispose() {
    _displayNameController.dispose();
    _displayImageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UpdateProfileScreenViewModel(),
      child: Consumer<UpdateProfileScreenViewModel>(
        builder: (context, value, child) => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Update Profile',
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: 20.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InputField(
                    controller: _displayNameController,
                    label: 'Display Name',
                    hint: 'Drake',
                  ),
                  20.vSpace,
                  InputField(
                    controller: _displayImageController,
                    label: 'Display Image',
                    hint: 'www.sample.jpg',
                  ),
                  20.vSpace,
                  Button(
                    onTap: () => value.updateProfile(
                      _displayNameController.text,
                      _displayImageController.text,
                      () => Navigator.of(context).pop(),
                    ),
                    title: 'Update Profile',
                    loading: value.loading,
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
