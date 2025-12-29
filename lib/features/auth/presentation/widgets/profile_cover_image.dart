import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileCoverImage extends StatelessWidget {
  const ProfileCoverImage({
    super.key,
    required this.coverHeight,
    required this.businessAvatarUrl,
  });

  final String? businessAvatarUrl;
  final double coverHeight;

  @override
  Widget build(BuildContext context) {
    // If we have a URL, attempt to load the Network Image
    if (businessAvatarUrl != null && businessAvatarUrl!.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Theme.brightnessOf(context) == Brightness.light
                  ? Colors.black12
                  : Colors.white12,
            ),
          ),
        ),
        child: CachedNetworkImage(
          imageUrl: businessAvatarUrl!,
          width: double.infinity,
          fit: BoxFit.cover,
          height: coverHeight,
          // This handles network failures or 404s
          errorWidget: (context, url, error) => _buildPlaceholder(),
          // Show a loading spinner while the image downloads
          placeholder: (context, url) => SizedBox(
            height: coverHeight,
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    }

    // Default fallback if URL is null
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Image.asset(
      'assets/images/cover-image.png',
      width: double.infinity,
      fit: BoxFit.cover,
      height: coverHeight,
    );
  }
}
