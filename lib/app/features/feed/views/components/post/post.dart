// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/nostr/providers/nostr_entity_provider.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/feed_item_footer.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/post_body.dart';
import 'package:ion/app/features/feed/views/components/post/components/quoted_post_frame/quoted_post_frame.dart';
import 'package:ion/app/features/feed/views/components/post/post_skeleton.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/feed/views/components/user_info_menu/user_info_menu.dart';
import 'package:ion/app/features/nostr/model/event_pointer.dart';

class Post extends ConsumerWidget {
  const Post({
    required this.eventPointer,
    this.header,
    this.footer,
    super.key,
  });

  final EventPointer eventPointer;
  final Widget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postEntity =
        ref.watch(nostrEntityProvider(eventPointer: eventPointer)).valueOrNull as PostEntity?;

    if (postEntity == null) {
      return const Skeleton(child: PostSkeleton());
    }

    final quotedEvent = postEntity.data.quotedEvent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.0.s),
        header ??
            UserInfo(
              pubkey: eventPointer.pubkey,
              trailing: UserInfoMenu(pubkey: eventPointer.pubkey),
            ),
        SizedBox(height: 10.0.s),
        PostBody(postEntity: postEntity),
        if (quotedEvent != null)
          Padding(
            padding: EdgeInsets.only(top: 6.0.s),
            child: QuotedPostFrame(
              child: Post(
                eventPointer:
                    EventPointer(eventId: quotedEvent.eventId, pubkey: quotedEvent.pubkey),
                header: UserInfo(pubkey: quotedEvent.pubkey),
                footer: const SizedBox.shrink(),
              ),
            ),
          ),
        footer ?? FeedItemFooter(eventPointer: eventPointer, kind: PostEntity.kind),
      ],
    );
  }
}
