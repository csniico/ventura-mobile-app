import 'package:flutter/material.dart';

class ProfileUserImage extends StatelessWidget {
  const ProfileUserImage({
    super.key,
    required this.profileHeight,
    this.imageUrl,
  });

  final double profileHeight;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: profileHeight,
      height: profileHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1),
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surfaceBright,
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildPlaceholder(),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Image.asset('assets/images/icon.png', fit: BoxFit.cover);
  }
}
