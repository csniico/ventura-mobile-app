import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class NotSignedInPage extends StatelessWidget {
  const NotSignedInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text("UnAuthenticated"),
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/sign-in',
                (_) => false,
              );
            },
            child: Row(
              children: [
                HugeIcon(icon: HugeIcons.strokeRoundedTissuePaper),
                Text("SigIn"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
