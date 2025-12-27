import 'package:flutter/material.dart';

class ProfileUserImage extends StatelessWidget {
  const ProfileUserImage({super.key, required this.profileHeight});

  final double profileHeight;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: profileHeight / 2,
      backgroundColor: Colors.grey,
      backgroundImage: NetworkImage(
        'https://csniico-ventura-bucket.s3.eu-west-2.amazonaws.com/images/17a84c27-9053-49f4-8a4a-3fc234261a5b.jpeg',
      ),
    );
  }
}
