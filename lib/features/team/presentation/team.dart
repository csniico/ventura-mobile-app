import 'package:flutter/material.dart';

class Team extends StatefulWidget {
  const Team({super.key});

  @override
  State<Team> createState() => _TeamState();
}

class _TeamState extends State<Team> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Team")),
      body: SafeArea(child: Column(children: [Text("Accounting")])),
    );
  }
}
