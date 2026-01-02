import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/config/routes.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/auth/presentation/pages/profile.dart';
import 'package:ventura/features/home/presentation/pages/not_signed_in_page.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  final AppRoutes routes = AppRoutes.instance;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {},
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        state.user.avatarUrl == null ||
                                state.user.avatarUrl!.isEmpty
                            ? _buildPlaceholder()
                            : ClipOval(
                                child: CachedNetworkImage(
                                  width: 50,
                                  height: 50,
                                  imageUrl: state.user.avatarUrl!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      _buildPlaceholder(),
                                ),
                              ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.user.firstName,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (state.user.business?.name != null) ...[
                              state.user.business!.name.length > 30
                                  ? Text(
                                      '${state.user.business!.name.substring(0, 20)}...',
                                    )
                                  : Text(state.user.business!.name),
                            ],
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(routes.search);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.all(12),
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedSearch01,
                          size: 30,
                          strokeWidth: 2,
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

  Widget _buildPlaceholder() {
    return Image.asset('assets/images/icon.png', fit: BoxFit.cover);
  }
}
