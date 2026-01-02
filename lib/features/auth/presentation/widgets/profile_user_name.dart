import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ProfileUserName extends StatelessWidget {
  const ProfileUserName({
    super.key,
    required this.businessName,
    required this.userName,
  });

  final String userName;
  final String businessName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            userName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedCheckmarkBadge01,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(width: 5),
              businessName.length > 30
                  ? Text('${businessName.substring(0, 30)}...')
                  : Text(businessName),
            ],
          ),
        ],
      ),
    );
  }
}
