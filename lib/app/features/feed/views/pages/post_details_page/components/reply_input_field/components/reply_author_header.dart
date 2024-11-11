// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/feed/views/components/replying_to/replying_to.dart';

class ReplyAuthorHeader extends StatelessWidget {
  const ReplyAuthorHeader({
    required this.postEntity,
    super.key,
  });

  final PostEntity postEntity;

  @override
  Widget build(BuildContext context) {
    const postAuthorName = 'markpoland';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListItem.user(
          title: const Text('Arnold Grey'),
          subtitle: const Text('@arnoldgrey'),
          profilePicture: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
          iceBadge: true,
          verifiedBadge: true,
        ),
        SizedBox(height: 6.0.s),
        const ReplyingTo(name: postAuthorName),
      ],
    );
  }
}
