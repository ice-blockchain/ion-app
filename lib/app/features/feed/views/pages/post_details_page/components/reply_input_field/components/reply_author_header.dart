import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/data/models/post/post_data.dart';
import 'package:ice/app/features/feed/views/components/post_replies/replying_to.dart';

class ReplyAuthorHeader extends StatelessWidget {
  const ReplyAuthorHeader({
    required this.postData,
    super.key,
  });

  final PostData postData;

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
