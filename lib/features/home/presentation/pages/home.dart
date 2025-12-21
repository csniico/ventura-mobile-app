import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/home/presentation/pages/home_dashboard_page.dart';
import 'package:ventura/features/home/presentation/pages/not_signed_in_page.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        debugPrint(state.toString());
      },
      builder: (context, state) {
        if (state is AuthSuccess) {
          return HomeDashboardPage();
        }
        return NotSignedInPage();
      },
    );
  }
}
