// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/feed_item_footer.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/post_body.dart';
import 'package:ion/app/features/feed/views/components/post/components/quoted_post_frame/quoted_post_frame.dart';
import 'package:ion/app/features/feed/views/components/post/post_skeleton.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/feed/views/components/user_info_menu/user_info_menu.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/nostr/providers/nostr_entity_provider.dart';

class Post extends ConsumerWidget {
  const Post({
    required this.eventReference,
    this.header,
    this.footer,
    this.showParent = false,
    super.key,
  });

  final EventReference eventReference;
  final bool showParent;
  final Widget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postEntity =
        ref.watch(nostrEntityProvider(eventReference: eventReference)).valueOrNull as PostEntity?;

    if (postEntity == null) {
      return const Skeleton(child: PostSkeleton());
    }

    final framedEvent = _getFramedEventReference(postEntity);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.0.s),
        header ??
            UserInfo(
              pubkey: eventReference.pubkey,
              trailing: UserInfoMenu(pubkey: eventReference.pubkey),
            ),
        SizedBox(height: 10.0.s),
        PostBody(postEntity: postEntity),
        if (framedEvent != null) _FramedEvent(eventReference: framedEvent),
        footer ?? FeedItemFooter(eventReference: eventReference, kind: PostEntity.kind),
      ],
    );
  }

  EventReference? _getFramedEventReference(PostEntity postEntity) {
    if (showParent) {
      final parentEvent = postEntity.data.parentEvent;
      if (parentEvent != null) {
        return EventReference(eventId: parentEvent.eventId, pubkey: parentEvent.pubkey);
      }
    } else {
      final quotedEvent = postEntity.data.quotedEvent;
      if (quotedEvent != null) {
        return EventReference(eventId: quotedEvent.eventId, pubkey: quotedEvent.pubkey);
      }
    }
    return null;
  }
}

class _FramedEvent extends StatelessWidget {
  const _FramedEvent({required this.eventReference});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6.0.s),
      child: QuotedPostFrame(
        child: Post(
          eventReference: eventReference,
          header: UserInfo(pubkey: eventReference.pubkey),
          footer: const SizedBox.shrink(),
        ),
      ),
    );
  }
}
