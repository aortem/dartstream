import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String? title;
  final VoidCallback onTap;
  final bool loading;
  const Button({
    super.key,
    required this.onTap,
    required this.title,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      color: Colors.purple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      textColor: Colors.white,
      textTheme: ButtonTextTheme.normal,
      child: loading
          ? const SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Text(title ?? ''),
    );
  }
}
