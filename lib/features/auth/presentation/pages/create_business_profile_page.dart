import 'package:flutter/material.dart';
import 'package:ventura/features/auth/presentation/widgets/business_who_are_you.dart';

class CreateBusinessProfilePage extends StatefulWidget {
  final String userId;
  final String firstName;

  const CreateBusinessProfilePage({
    super.key,
    required this.userId,
    required this.firstName,
  });

  @override
  State<CreateBusinessProfilePage> createState() =>
      _CreateBusinessProfilePageState();
}

class _CreateBusinessProfilePageState extends State<CreateBusinessProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: PageView(
          children: [
            Center(
              child: Text('Create Business Profile 1 for ${widget.firstName}'),
            ),
            BusinessWhoAreYou(),
            Center(
              child: Text('Create Business Profile 3 for ${widget.firstName}'),
            ),
            Center(
              child: Text('Create Business Profile 4 for ${widget.firstName}'),
            ),
          ],
        ),
      ),
    );
  }
}
