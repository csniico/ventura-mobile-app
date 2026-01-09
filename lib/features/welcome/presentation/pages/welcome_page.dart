import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/core/presentation/widgets/text_component.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomeState();
}

class _WelcomeState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticating) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/icon.png",
                        height: 100,
                        color: Theme.of(context).primaryColor,
                      ),
                      TextComponent(text: "Welcome to Ventura", type: "title"),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 70,
                    right: 70,
                    bottom: 40,
                  ),
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/sign-in'),
                    child: Text("Continue"),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
