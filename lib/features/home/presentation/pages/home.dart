import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        debugPrint(state.toString());
      },
      builder: (context, state) {
        return Column(
          children: [
            Center(child: Text("Home")),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/details');
              },
              child: Row(
                children: [
                  HugeIcon(icon: HugeIcons.strokeRoundedTissuePaper),
                  Text("Go to Details"),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
