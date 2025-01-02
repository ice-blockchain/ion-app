// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/user/follow_user_button/follow_user_button.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/views/components/article/components/article_image/article_image.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/utils/algorithm.dart';

class ArticleDetailsHeader extends ConsumerWidget {
  const ArticleDetailsHeader({
    required this.article,
    super.key,
  });

  final ArticleEntity article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColoredBox(
      color: context.theme.appColors.onPrimaryAccent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenSideOffset.defaultSmallMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.data.title ?? '',
              style: context.theme.appTextThemes.headline2
                  .copyWith(color: context.theme.appColors.primaryText),
            ),
            SizedBox(height: 10.0.s),
            ArticleImage(
              imageUrl: article.data.image,
              minutesToRead: calculateReadingTime(article.data.content),
            ),
            SizedBox(height: 12.0.s),
            UserInfo(
              pubkey: article.masterPubkey,
              trailing: FollowUserButton(pubkey: article.masterPubkey),
            ),
          ],
        ),
      ),
    );
  }
}
