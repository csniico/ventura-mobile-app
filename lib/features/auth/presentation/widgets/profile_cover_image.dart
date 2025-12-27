import 'package:flutter/material.dart';

class ProfileCoverImage extends StatelessWidget {
  const ProfileCoverImage({super.key, required this.coverHeight});

  final double coverHeight;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://csniico-ventura-bucket.s3.eu-west-2.amazonaws.com/images/17a84c27-9053-49f4-8a4a-3fc234261a5b.jpeg',
      width: double.infinity,
      fit: BoxFit.cover,
      height: coverHeight,
    );
  }
}
