import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/auth/presentation/resources/profile_page_section_lists.dart';
import 'package:ventura/features/auth/presentation/widgets/profile_page_header.dart';
import 'package:ventura/features/auth/presentation/widgets/profile_section.dart';
import 'package:ventura/features/auth/presentation/widgets/profile_user_name.dart';

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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/sign-in', (_) => false);
          }
        },
        builder: (context, state) {
          if (state is AuthSuccess) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ProfilePageHeader(
                    businessAvatarUrl: state.user.business?.logo,
                    userAvatarUrl: state.user.avatarUrl,
                  ),
                  // user name and business name
                  ProfileUserName(
                    businessName: state.user.business?.name ?? '',
                    userName:
                        '${state.user.firstName} ${state.user.lastName ?? ''}'
                            .trim(),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // account management
                        ProfileSection(
                          key: ValueKey('accountManagement'),
                          items: accountManagement,
                          sectionName: 'Account Management',
                        ),
                        SizedBox(height: 40),

                        // app settings
                        ProfileSection(
                          key: ValueKey('appSettings'),
                          items: appSettings,
                          sectionName: 'Settings',
                        ),
                        SizedBox(height: 40),

                        // support and legal
                        ProfileSection(
                          key: ValueKey('supportAndLegal'),
                          items: supportAndLegal,
                          sectionName: 'Support & Legal',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FutureBuilder<String>(
                          future: getAppVersion(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return const SizedBox();
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                snapshot.data!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(child: Text('Loading...'));
        },
      ),
    );
  }
}
