// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/article/components/article_header/article_header.dart';
import 'package:ion/app/features/feed/views/components/article/components/article_image/article_image.dart';
import 'package:ion/app/features/feed/views/components/article/components/bookmark_button/bookmark_button.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';
import 'package:ion/app/utils/username.dart';

class Article extends StatelessWidget {
  const Article({
    required this.id,
    required this.userMetadata,
    required this.publishedAt,
    required this.imageUrl,
    required this.minutesToRead,
    required this.title,
    super.key,
  });

  final String id;

  final UserMetadata userMetadata;

  final DateTime publishedAt;

  final String imageUrl;

  final int minutesToRead;

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListItem.user(
          title: Text(userMetadata.displayName),
          subtitle: Text(prefixUsername(username: userMetadata.name, context: context)),
          profilePicture: userMetadata.picture,
          verifiedBadge: userMetadata.verified,
          ntfAvatar: userMetadata.nft,
          timeago: publishedAt,
          onTap: () {},
          trailing: const BookmarkButton(id: 'test_article_id'),
        ),
        SizedBox(height: 10.0.s),
        ArticleImage(
          imageUrl: imageUrl,
          minutesToRead: minutesToRead,
        ),
        SizedBox(height: 16.0.s),
        ArticleHeader(text: title),
      ],
    );
  }
}
