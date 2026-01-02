import 'package:flutter/material.dart';
import 'package:ventura/features/auth/presentation/widgets/profile_cover_image.dart';
import 'package:ventura/features/auth/presentation/widgets/profile_user_image.dart';

class ProfilePageHeader extends StatelessWidget {
  const ProfilePageHeader({
    super.key,
    required this.businessAvatarUrl,
    required this.userAvatarUrl,
  });

  final String? userAvatarUrl;
  final String? businessAvatarUrl;

  @override
  Widget build(BuildContext context) {
    final double profileHeight = 104;
    final double coverHeight = 160;
    final double profileTopSpacing = coverHeight - (profileHeight / 2);

    return Container(
      margin: EdgeInsets.only(bottom: profileHeight / 2),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          ProfileCoverImage(
            coverHeight: coverHeight,
            businessAvatarUrl: businessAvatarUrl,
          ),
          Positioned(
            top: profileTopSpacing,
            child: ProfileUserImage(
              profileHeight: profileHeight,
              imageUrl: userAvatarUrl,
            ),
          ),
        ],
      ),
    );
  }
}
