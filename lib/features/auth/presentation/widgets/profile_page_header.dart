import 'package:flutter/material.dart';
import 'package:ventura/features/auth/presentation/widgets/profile_cover_image.dart';
import 'package:ventura/features/auth/presentation/widgets/profile_user_image.dart';

class ProfilePageHeader extends StatelessWidget {
  const ProfilePageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final double profileHeight = 144;
    final double coverHeight = 280;
    final double profileTopSpacing = coverHeight - (profileHeight / 2);

    return Container(
      margin: EdgeInsets.only(bottom: profileHeight / 2),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          ProfileCoverImage(coverHeight: coverHeight),
          Positioned(
            top: profileTopSpacing,
            child: ProfileUserImage(profileHeight: profileHeight),
          ),
        ],
      ),
    );
  }
}
