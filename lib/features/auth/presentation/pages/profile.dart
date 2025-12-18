import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/presentation/widgets/secondary_app_bar.dart';
import 'package:ventura/core/presentation/widgets/text_component.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: TextComponent(
          text: "Are you sure you want to sign out?",
          type: "title",
          size: 16,
        ),
        content: TextComponent(
          type: "body",
          text:
              "Your current session will expire and you will lose data that has not been synced. Make sure you sync all data before proceeding.",
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel", style: TextStyle(fontSize: 16)),
                ),
                TextButton(
                  onPressed: () async {
                    context.read<AuthBloc>().add(AuthSignOut());
                  },
                  child: Text(
                    "Logout",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: SecondaryAppBar(title: "Profile"),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/sign-in', (_) => false);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Center(child: Text("Profile")),
                _logoutButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _logoutButton() {
    return TextButton(
      onPressed: _logout,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.primary,
          border: Border.all(color: const Color(0xFF4285F4), width: 1.5),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedDoor01,
              size: 20,
              strokeWidth: 3,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            TextComponent(
              text: 'Sign out',
              type: 'title',
              size: 14,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
