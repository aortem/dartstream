import 'package:firebase_dart_admin_auth_sample_app/utils/extensions.dart';
import 'package:flutter/material.dart';

class ActionTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const ActionTile({
    super.key,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: 10.all,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.purple,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}
