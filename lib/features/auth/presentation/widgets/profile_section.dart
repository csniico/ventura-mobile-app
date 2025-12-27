import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/presentation/widgets/text_component.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/auth/presentation/resources/profile_page_section_lists.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({
    super.key,
    required this.items,
    required this.sectionName,
  });

  final String sectionName;
  final List<ProfilePageSectionLists> items;

  void handleOnTap(ProfilePageSectionLists item, BuildContext context) {
    debugPrint('Label: ${item.label}, Route: ${item.route}');

    if (item.label == 'logout') {
      _logout(context);
    } else if (item.route != null) {
      Navigator.of(context).pushNamed('/${item.route}');
    }
  }

  Future<void> _logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8),
          child: TextComponent(
            text: sectionName,
            type: 'title',
            size: 16,
            color: Theme.brightnessOf(context) == Brightness.light
                ? Colors.black38
                : Colors.white38,
          ),
        ),
        Card(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 8),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (_, index) =>
                ListTile(
                  onTap: () => handleOnTap(items[index], context),
                  contentPadding: EdgeInsets.all(8),
                  title: Text(
                    items[index].title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: items[index].label == 'logout' ? Colors.red : null,
                    ),
                  ),
                  leading: HugeIcon(
                    icon: items[index].icon,
                    color: items[index].label == 'logout' ? Colors.red : null,
                  ),
                  trailing: HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowRight01,
                    color: items[index].label == 'logout' ? Colors.red : null,
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
