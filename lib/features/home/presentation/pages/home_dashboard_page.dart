import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/common/routes.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/home/presentation/pages/not_signed_in_page.dart';
import 'package:ventura/core/common/utils/date_time_util.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  final AppRoutes routes = AppRoutes.instance;

  @override
  Widget build(BuildContext context) {
    final darkGrey = Theme.brightnessOf(context) == Brightness.light
        ? Colors.black54
        : Colors.white54;
    final lightGrey = Theme.brightnessOf(context) == Brightness.light
        ? Colors.black12
        : Colors.white12;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is AuthSuccess) {
          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, ${state.user.firstName}!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          formatWithSuffix(DateTime.now()),
                          style: TextStyle(color: darkGrey),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(routes.search);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: lightGrey,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.all(12),
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedSearch01,
                          size: 24,
                          color: Theme.brightnessOf(context) == Brightness.light
                              ? Colors.grey[700]
                              : Colors.grey[400],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 40),
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
            ),
          );
        }
        return const Center(child: NotSignedInPage());
      },
    );
  }
}
