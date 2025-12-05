import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: Text("Home"),),
        TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/details');
            },
            child: Row(
              children: [
                HugeIcon(icon: HugeIcons.strokeRoundedTissuePaper),
                Text("Go to Details")
              ],
            )
        )
      ],
    );
  }
}
