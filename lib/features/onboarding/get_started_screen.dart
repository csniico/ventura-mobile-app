import 'package:flutter/material.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Text("Welcome to Ventura"),
            Text("""
              Manage your sales, customers, appointments, inventory, marketing,
              and more - all in one place, to streamline your business operations.
              """),
            TextButton(onPressed: () {}, child: Text("Get Started")),
          ],
        ),
      ),
    );
  }
}
