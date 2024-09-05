import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/num.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({
    super.key,
    this.trailing,
  });

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.0.s),
      child: ListItem.user(
        title: const Text('Arnold Grey'),
        subtitle: const Text('@arnoldgrey'),
        profilePicture: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
        trailing: trailing,
        constraints: BoxConstraints(minHeight: 55.0.s),
        iceBadge: Random().nextBool(),
        verifiedBadge: Random().nextBool(),
        ntfAvatar: Random().nextBool(),
      ),
    );
  }
}
