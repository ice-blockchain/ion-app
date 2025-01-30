// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/components/entities_list/components/bookmark_button/bookmark_button.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/views/components/article/components/article_footer/article_footer.dart';
import 'package:ion/app/features/feed/views/components/article/components/article_image/article_image.dart';
import 'package:ion/app/features/feed/views/components/overlay_menu/own_entity_menu.dart';
import 'package:ion/app/features/feed/views/components/overlay_menu/user_info_menu.dart';
import 'package:ion/app/features/feed/views/components/post/post_skeleton.dart';
import 'package:ion/app/features/feed/views/components/timestamp_widget.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/utils/algorithm.dart';
import 'package:ion/app/utils/color.dart';

class Article extends ConsumerWidget {
  const Article({
    required this.eventReference,
    this.showActionButtons = true,
    this.timeFormat = TimestampFormat.short,
    super.key,
  });

  factory Article.quoted({
    required EventReference eventReference,
  }) {
    return Article(eventReference: eventReference, showActionButtons: false);
  }

  final EventReference eventReference;
  final bool showActionButtons;
  final TimestampFormat timeFormat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articleEntity = ref
        .watch(ionConnectEntityProvider(eventReference: eventReference))
        .valueOrNull as ArticleEntity?;

    if (articleEntity == null) {
      return const Skeleton(child: PostSkeleton());
    }

    final isOwnedByCurrentUser =
        ref.watch(isCurrentUserSelectorProvider(articleEntity.masterPubkey));

    return ColoredBox(
      color: context.theme.appColors.onPrimaryAccent,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              width: 4.0.s,
              decoration: BoxDecoration(
                color: articleEntity.data.colorLabel != null
                    ? fromHexColor(articleEntity.data.colorLabel!.value)
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
                    pubkey: eventReference.pubkey,
                    createdAt: articleEntity.data.publishedAt.value,
                    timeFormat: timeFormat,
                    trailing: showActionButtons
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              BookmarkButton(eventReference: eventReference),
                              if (isOwnedByCurrentUser)
                                OwnEntityMenu(eventReference: eventReference)
                              else
                                UserInfoMenu(pubkey: eventReference.pubkey),
                            ],
                          )
                        : null,
                  ),
                  SizedBox(height: 10.0.s),
                  ArticleImage(
                    imageUrl: articleEntity.data.image,
                    minutesToRead: calculateReadingTime(articleEntity.data.content),
                  ),
                  SizedBox(height: 10.0.s),
                  ArticleFooter(text: articleEntity.data.title ?? ''),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
