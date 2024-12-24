import 'package:firebase/utils/extensions.dart';
import 'package:flutter/material.dart';

class ActionTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  const ActionTile({
    super.key,
    required this.onTap,
    required this.title,
    this.loading = false,
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
            loading
                ? const SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(),
                  )
                : Text(title),
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
