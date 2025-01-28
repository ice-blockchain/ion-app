// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/create_article/providers/draft_article_provider.c.dart';
import 'package:ion/app/features/feed/create_article/views/pages/create_article_preview_modal/components/article_preview_image.dart';
import 'package:ion/app/features/feed/views/components/article/components/article_footer/article_footer.dart';
import 'package:ion/app/features/feed/views/components/post/post_skeleton.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/feed/views/components/user_info_menu/user_info_menu.dart';
import 'package:ion/app/utils/algorithm.dart';

class ArticlePreview extends ConsumerWidget {
  const ArticlePreview({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DraftArticleState(:title, :image, :content, :imageColor) =
        ref.watch(draftArticleProvider);

    final currentPubkey = ref.watch(currentPubkeySelectorProvider).valueOrNull;

    if (currentPubkey == null) {
      return const Skeleton(child: PostSkeleton());
    }

    return ColoredBox(
      color: context.theme.appColors.onPrimaryAccent,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              width: 4.0.s,
              decoration: BoxDecoration(
                color: imageColor != null
                    ? Color(int.parse(imageColor.replaceAll('#', '0xff')))
                    : context.theme.appColors.primaryAccent,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4.0.s),
                  bottomRight: Radius.circular(4.0.s),
                ),
              ),
            ),
            SizedBox(width: 12.0.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserInfo(
                    pubkey: currentPubkey,
                    trailing: UserInfoMenu(pubkey: currentPubkey),
                  ),
                  SizedBox(height: 10.0.s),
                  ArticlePreviewImage(
                    mediaFile: image,
                    minutesToRead: calculateReadingTime(content),
                  ),
                  SizedBox(height: 10.0.s),
                  ArticleFooter(text: title),
                ],
              ),
            ),
            SizedBox(width: 16.0.s),
          ],
        ),
      ),
    );
  }
}
