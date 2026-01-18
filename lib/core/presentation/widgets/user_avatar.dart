import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.profileHeight,
    required this.imageUrl,
  });

  final double profileHeight;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: profileHeight,
      height: profileHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
          width: 1,
        ),
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surfaceBright,
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => _buildPlaceholder(),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Image.asset('assets/images/icon.png', fit: BoxFit.cover);
  }
}
