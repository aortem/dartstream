import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final String? label;
  final bool? obscure;
  final TextInputType? textInputType;
  const InputField({
    super.key,
    this.controller,
    this.hint,
    this.label,
    this.obscure,
    this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure ?? false,
      keyboardType: textInputType,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
      ),
    );
  }
}
