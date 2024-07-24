import 'package:dart_admin_auth_sample_app/shared/shared.dart';
import 'package:dart_admin_auth_sample_app/utils/extensions.dart';
import 'package:flutter/material.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _displayNameController = TextEditingController();

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Button(
                onTap: () {},
                title: 'Update Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
