import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/auth/presentation/widgets/profile_user_image.dart';

class ViewPersonalProfilePage extends StatelessWidget {
  const ViewPersonalProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/edit-profile-page');
            },
            icon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: HugeIcon(icon: HugeIcons.strokeRoundedPencilEdit02),
            ),
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Center(
                          child: ProfileUserImage(
                            profileHeight: 84,
                            imageUrl: state.user.avatarUrl,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${state.user.firstName} ${state.user.lastName ?? ''}',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.user.email,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Account Information',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildProfileItem(
                      context,
                      icon: HugeIcons.strokeRoundedComputer,
                      title: 'Profile Type',
                      value: state.user.isSystem ? 'Owner' : 'Team Member',
                    ),
                    const SizedBox(height: 8),
                    _buildProfileItem(
                      context,
                      icon: HugeIcons.strokeRoundedCheckmarkBadge01,
                      title: 'Account Status',
                      value: state.user.isActive ? 'Active' : 'Inactive',
                    ),
                    const SizedBox(height: 8),
                    _buildProfileItem(
                      context,
                      icon: HugeIcons.strokeRoundedMailValidation01,
                      title: 'Email Status',
                      value: state.user.isEmailVerified
                          ? 'Verified'
                          : 'Unverified',
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Data & Privacy',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildActionItem(
                      context,
                      icon: HugeIcons.strokeRoundedDownload01,
                      title: 'Download Data',
                      onTap: () {},
                    ),
                    const SizedBox(height: 8),
                    _buildActionItem(
                      context,
                      icon: HugeIcons.strokeRoundedDelete02,
                      title: 'Delete Account',
                      color: Theme.of(context).colorScheme.error,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(child: Text('Loading...'));
        },
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context, {
    required List<List<dynamic>> icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: HugeIcon(icon: icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w400)),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required List<List<dynamic>> icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: HugeIcon(icon: icon, color: color),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w400, color: color),
        ),
        trailing: HugeIcon(
          icon: HugeIcons.strokeRoundedArrowRight01,
          color: color,
        ),
        onTap: onTap,
      ),
    );
  }
}
