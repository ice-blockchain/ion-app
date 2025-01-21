// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/features/components/entities_list/components/repost_author_header.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class RepostListItem extends StatelessWidget {
  const RepostListItem({required this.repost, super.key});

  final RepostEntity repost;

  @override
  Widget build(BuildContext context) {
    final eventReference = EventReference(eventId: repost.data.eventId, pubkey: repost.data.pubkey);
    final repostEventReference = EventReference(eventId: repost.id, pubkey: repost.pubkey);

    return GestureDetector(
      onTap: () => PostDetailsRoute(eventReference: eventReference.toString()).push<void>(context),
      behavior: HitTestBehavior.opaque,
      child: ScreenSideOffset.small(
        child: Column(
          children: [
            RepostAuthorHeader(pubkey: repost.masterPubkey),
            Post(eventReference: eventReference, repostEventReference: repostEventReference),
          ],
        ),
      ),
    );
  }
}
