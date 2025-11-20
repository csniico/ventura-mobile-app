import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/app/app.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ventura"),
        centerTitle: true,
      ),
      body: Column(
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
      ),
    );
  }
}
