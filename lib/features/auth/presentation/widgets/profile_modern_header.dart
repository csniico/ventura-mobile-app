import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ProfileModernHeader extends StatelessWidget {
  const ProfileModernHeader({
    super.key,
    required this.userAvatarUrl,
    required this.userName,
    required this.businessName,
  });

  final String? userAvatarUrl;
  final String userName;
  final String businessName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const double avatarRadius = 54;

    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 10),
      child: Column(
        children: [
          // Avatar with edit button
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.scaffoldBackgroundColor,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)
                  )
                ),
                child: CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: theme.colorScheme.surface,
                  child: ClipOval(
                    child: _buildAvatar(context, avatarRadius * 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // User name
          Text(
            userName.isNotEmpty ? userName : 'User',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),

          // Business name with verification badge
          if (businessName.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedCheckmarkBadge01,
                    color: theme.colorScheme.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    businessName.length > 25
                        ? '${businessName.substring(0, 25)}...'
                        : businessName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, double size) {
    if (userAvatarUrl != null && userAvatarUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: userAvatarUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: size,
          height: size,
          color: Theme.of(context).colorScheme.surface,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => _buildPlaceholderAvatar(size),
      );
    }
    return _buildPlaceholderAvatar(size);
  }

  Widget _buildPlaceholderAvatar(double size) {
    return Image.asset(
      'assets/images/icon.png',
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }
}

