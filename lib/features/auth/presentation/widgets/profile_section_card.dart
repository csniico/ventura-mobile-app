import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/features/auth/presentation/resources/profile_page_section_lists.dart';

class ProfileSectionCard extends StatelessWidget {
  const ProfileSectionCard({
    super.key,
    required this.sectionName,
    required this.items,
    required this.icon,
  });

  final String sectionName;
  final List<ProfilePageSectionLists> items;
  final dynamic icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                Text(
                  sectionName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          // List items
          ...items.asMap().entries.map((entry) {
            final item = entry.value;

            return Column(children: [_buildListTile(context, item)]);
          }),

          // Bottom padding
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, ProfilePageSectionLists item) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (item.route != null) {
            Navigator.of(context).pushNamed('/${item.route}');
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.08)
                    : theme.colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: HugeIcon(
                icon: item.icon,
                color: item.color ?? theme.colorScheme.onSurfaceVariant,
                size: 22,
              ),
            ),
            title: Text(
              item.title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: item.color ?? theme.colorScheme.onSurface,
              ),
            ),
            trailing: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowRight01,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
