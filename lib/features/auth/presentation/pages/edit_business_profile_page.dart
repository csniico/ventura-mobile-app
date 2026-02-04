import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/auth/presentation/pages/create_business_profile_page.dart';

class EditBusinessProfilePage extends StatelessWidget {
  const EditBusinessProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          builder: (_, state) {
            if (state is Authenticated) {
              return CreateBusinessProfilePage(
                user: state.user,
                isUpdating: true,
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
          listener: (_, state) {},
        ),
      ),
    );
  }
}
