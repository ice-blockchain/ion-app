// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/counter_items_footer.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/components/entities_list/components/bookmark_button/bookmark_button.dart';
import 'package:ion/app/features/feed/create_post/views/pages/post_form_modal/components/parent_entity.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/providers/ion_connect_entity_with_counters_provider.c.dart';
import 'package:ion/app/features/feed/views/components/article/components/article_footer/article_footer.dart';
import 'package:ion/app/features/feed/views/components/article/components/article_image/article_image.dart';
import 'package:ion/app/features/feed/views/components/deleted_entity/deleted_entity.dart';
import 'package:ion/app/features/feed/views/components/overlay_menu/own_entity_menu.dart';
import 'package:ion/app/features/feed/views/components/overlay_menu/user_info_menu.dart';
import 'package:ion/app/features/feed/views/components/post/post_skeleton.dart';
import 'package:ion/app/features/feed/views/components/time_ago/time_ago.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/utils/algorithm.dart';
import 'package:ion/app/utils/color.dart';

class Article extends ConsumerWidget {
  const Article({
    required this.eventReference,
    this.showActionButtons = true,
    this.timeFormat = TimestampFormat.short,
    this.header,
    this.isReplied = false,
    this.footer,
    super.key,
  });

  factory Article.quoted({
    required EventReference eventReference,
  }) {
    return Article(eventReference: eventReference, showActionButtons: false);
  }

  factory Article.replied({
    required EventReference eventReference,
  }) {
    return Article(
      eventReference: eventReference,
      showActionButtons: false,
      isReplied: true,
    );
  }

  final EventReference eventReference;
  final bool showActionButtons;
  final TimestampFormat timeFormat;
  final Widget? header;
  final bool isReplied;
  final Widget? footer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = ref.watch(ionConnectEntityWithCountersProvider(eventReference: eventReference));

    if (entity is! ArticleEntity) {
      return const Skeleton(child: PostSkeleton());
    }

    if (entity.isDeleted) {
      return Padding(
        padding: EdgeInsetsDirectional.only(start: 16.0.s),
        child: DeletedEntity(entityType: DeletedEntityType.article),
      );
    }

    final isOwnedByCurrentUser = ref.watch(isCurrentUserSelectorProvider(entity.masterPubkey));

    return ColoredBox(
      color: context.theme.appColors.onPrimaryAccent,
      child: Column(
        children: [
          if (isReplied && header != null)
            header!
          else if (isReplied) ...[
            UserInfo(
              pubkey: eventReference.pubkey,
              createdAt: entity.data.publishedAt.value,
              timeFormat: timeFormat,
              trailing: showActionButtons
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BookmarkButton(eventReference: eventReference),
                        if (isOwnedByCurrentUser)
                          OwnEntityMenu(eventReference: eventReference)
                        else
                          UserInfoMenu(eventReference: eventReference),
                      ],
                    )
                  : null,
            ),
            SizedBox(height: 10.0.s),
          ],
          ParentDottedLine(
            visible: isReplied,
            padding: EdgeInsetsDirectional.only(
              start: 15.0.s,
              end: 22.0.s,
              bottom: 4.0.s,
            ),
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        width: 4.0.s,
                        decoration: BoxDecoration(
                          color: entity.data.colorLabel != null
                              ? fromHexColor(entity.data.colorLabel!.value)
                              : context.theme.appColors.primaryAccent,
                          borderRadius: BorderRadiusDirectional.only(
                            topEnd: Radius.circular(4.0.s),
                            bottomEnd: Radius.circular(4.0.s),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.0.s),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isReplied && header != null)
                              header!
                            else if (!isReplied) ...[
                              UserInfo(
                                pubkey: eventReference.pubkey,
                                createdAt: entity.data.publishedAt.value,
                                timeFormat: timeFormat,
                                trailing: showActionButtons
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isOwnedByCurrentUser)
                                            OwnEntityMenu(eventReference: eventReference)
                                          else
                                            UserInfoMenu(eventReference: eventReference),
                                        ],
                                      )
                                    : null,
                              ),
                              SizedBox(height: 10.0.s),
                            ],
                            ArticleImage(
                              imageUrl: entity.data.image,
                              minutesToRead: calculateReadingTime(entity.data.content),
                            ),
                            SizedBox(height: 10.0.s),
                            ArticleFooter(text: entity.data.title ?? ''),
                            if (!isReplied)
                              footer ??
                                  CounterItemsFooter(
                                    eventReference: eventReference,
                                    bottomPadding: 0,
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isReplied) footer ?? CounterItemsFooter(eventReference: eventReference),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
