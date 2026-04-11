import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/config/routes.dart';
import 'package:ventura/core/presentation/widgets/user_avatar.dart';
import 'package:ventura/core/presentation/widgets/ventura_app_bar/app_bar_type.dart';
import 'package:ventura/core/services/user_service.dart';

class VenturaAppBar extends StatelessWidget implements PreferredSizeWidget {
  VenturaAppBar({
    super.key,
    this.type = AppBarType.secondary,
    this.title,
    this.onBackPressed,
    this.actions,
    this.backgroundColor,
    this.titleTextStyle,
    this.showBottomDivider = true,
    this.customLeading,
    this.centerTitle = false,
    this.profileImageUrl,
    this.userName,
    this.businessName,
    this.onSearchPressed,
  });

  final AppBarType type;
  final String? title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final TextStyle? titleTextStyle;
  final bool showBottomDivider;
  final Widget? customLeading;
  final bool centerTitle;

  /// Dashboard-specific fields
  final String? profileImageUrl;
  final String? userName;
  final String? businessName;
  final VoidCallback? onSearchPressed;

  final AppRoutes _appRoutes = AppRoutes.instance;
  final UserService _userService = UserService();

  String _optimizeText(String text) {
    if (text.length > 15) {
      return '${text.substring(0, 12)}...';
    }
    return text;
  }

  Widget? _buildLeading(BuildContext context) {
    if (customLeading != null) {
      return customLeading;
    }

    switch (type) {
      case AppBarType.dashboard:
        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: UserAvatar(
            profileHeight: 24.0,
            imageUrl: profileImageUrl ?? _userService.user?.avatarUrl,
          ),
        );

      case AppBarType.secondary:
      case AppBarType.minimal:
        return IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: _getTitleColor(context),
            size: 30,
          ),
          onPressed: onBackPressed ?? () => Navigator.pop(context),
        );
    }
  }

  Widget? _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    switch (type) {
      case AppBarType.dashboard:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _optimizeText(
                userName ?? _userService.user?.firstName ?? 'Ventura',
              ),
              style: theme.textTheme.titleLarge?.copyWith(
                color: _getTitleColor(context),
              ),
            ),
            Text(
              _optimizeText(
                businessName ?? _userService.user?.business?.name ?? 'ventura',
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                color: _getTitleColor(context),
              ),
            ),
          ],
        );

      case AppBarType.secondary:
      case AppBarType.minimal:
        return Text(
          title ?? '',
          style:
              titleTextStyle ??
              theme.textTheme.titleLarge?.copyWith(
                color: _getTitleColor(context),
              ),
        );
    }
  }

  Widget? _buildActions(BuildContext context) {
    if (type != AppBarType.dashboard) {
      return null;
    }

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: IconButton(
        onPressed:
            onSearchPressed ??
            () => Navigator.pushNamed(context, _appRoutes.search),
        icon: HugeIcon(
          icon: HugeIcons.strokeRoundedSearch01,
          color: _getTitleColor(context),
          size: 30,
        ),
      ),
    );
  }

  PreferredSize _buildBottomDivider() {
    final height = type == AppBarType.dashboard ? 12.0 : 8.0;
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: SizedBox(height: height),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (backgroundColor != null) return backgroundColor!;

    final colorScheme = Theme.of(context).colorScheme;
    return switch (type) {
      AppBarType.dashboard => colorScheme.surface,
      AppBarType.secondary || AppBarType.minimal => colorScheme.primary,
    };
  }

  Color _getTitleColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (type) {
      AppBarType.dashboard => colorScheme.onSurface,
      AppBarType.secondary || AppBarType.minimal => colorScheme.onPrimary,
    };
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: _getBackgroundColor(context),
      bottom: showBottomDivider ? _buildBottomDivider() : null,
      leading: _buildLeading(context),
      title: _buildTitle(context),
      centerTitle: centerTitle,
      actions: type == AppBarType.dashboard
          ? [_buildActions(context)!]
          : actions,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12.0);
}
