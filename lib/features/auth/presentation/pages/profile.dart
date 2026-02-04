import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/auth/presentation/resources/profile_page_section_lists.dart';
import 'package:ventura/features/auth/presentation/widgets/profile_section_card.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    return 'v${info.version}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/sign-in', (_) => false);
          }
        },
        builder: (context, state) {
          if (state is Authenticated) {
            return CustomScrollView(
              slivers: [
                // Modern header with user avatar, name and business
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  backgroundColor: theme.colorScheme.primary,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.3,
                              ),
                              backgroundImage: state.user.avatarUrl != null
                                  ? NetworkImage(state.user.avatarUrl!)
                                  : null,
                              child: state.user.avatarUrl == null
                                  ? Text(
                                      state.user.firstName.isNotEmpty
                                          ? state.user.firstName[0]
                                                .toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${state.user.firstName} ${state.user.lastName ?? ''}'
                                  .trim(),
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (state.user.business?.name != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  state.user.business!.name,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Sections with card-style grouping
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Account Management Section
                      ProfileSectionCard(
                        sectionName: 'Account Management',
                        items: accountManagement,
                        icon: HugeIcons.strokeRoundedUserCircle,
                      ),
                      const SizedBox(height: 16),

                      // App Settings Section
                      ProfileSectionCard(
                        sectionName: 'Settings',
                        items: appSettings,
                        icon: HugeIcons.strokeRoundedSettings01,
                      ),
                      const SizedBox(height: 16),

                      // Support & Legal Section (without logout)
                      ProfileSectionCard(
                        sectionName: 'Support & Legal',
                        items: supportAndLegalWithoutLogout,
                        icon: HugeIcons.strokeRoundedHelpCircle,
                      ),
                      const SizedBox(height: 24),

                      // Sign Out - Separated danger zone
                      _buildSignOutCard(context),
                      const SizedBox(height: 32),
                    ]),
                  ),
                ),

                // App version footer
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FutureBuilder<String>(
                        future: getAppVersion(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const SizedBox();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Text(
                              '${snapshot.data!}  •  © 2026 Ventura',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(color: theme.colorScheme.primary),
          );
        },
      ),
    );
  }

  Widget _buildSignOutCard(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      elevation: 0,
      margin: EdgeInsets.zero,
      child: ListTile(
        onTap: () => _showLogoutDialog(context),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedLogout02,
            color: Colors.red[700],
            size: 22,
          ),
        ),
        title: Text(
          'Sign Out',
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.red[700],
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'End your current session',
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.red[400]),
        ),
        trailing: HugeIcon(
          icon: HugeIcons.strokeRoundedArrowRight01,
          color: Colors.red[400],
          size: 20,
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedLogout02,
              color: Colors.red[700],
              size: 24,
            ),
            const SizedBox(width: 12),
            const Text('Sign Out'),
          ],
        ),
        content: Text(
          'Your current session will expire and you will lose data that has not been synced. Make sure you sync all data before proceeding.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () => context.read<AuthBloc>().add(AuthSignOut()),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }
}
