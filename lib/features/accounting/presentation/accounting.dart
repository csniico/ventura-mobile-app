import 'package:flutter/material.dart';

class Accounting extends StatefulWidget {
  const Accounting({super.key});

  @override
  State<Accounting> createState() => _AccountingState();
}

class _AccountingState extends State<Accounting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Accounting"),
        ),
        body: SafeArea(child: Column(children: [Text("Accounting")])));
  }
}
