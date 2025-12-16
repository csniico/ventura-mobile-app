import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/core/services/user_service.dart';

class UserAvatar extends StatefulWidget {
  const UserAvatar({super.key});

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  User? _user;
  bool _imageError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _user?.avatarUrl;

    if (imageUrl == null || imageUrl.isEmpty || _imageError) {
      return CircleAvatar(
        radius: 30,
        backgroundColor: Colors.white,
        child: HugeIcon(
          icon: HugeIcons.strokeRoundedUser,
          color: Theme.of(context).colorScheme.primary,
          size: 40,
        ),
      );
    }

    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.grey,
      backgroundImage: NetworkImage(imageUrl),
      onBackgroundImageError: (exception, stackTrace) {
        if (mounted) {
          setState(() {
            _imageError = true;
          });
        }
      },
    );
  }
}
