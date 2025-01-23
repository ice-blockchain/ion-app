// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/router/app_routes.c.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({required this.post, this.showParent = false, super.key});

  final ModifiablePostEntity post;

  final bool showParent;

  @override
  Widget build(BuildContext context) {
    final eventReference = post.toEventReference();
    // TODO: process 20002 in the feed provider to fetch 10002

    return GestureDetector(
      onTap: () => PostDetailsRoute(eventReference: eventReference.encode()).push<void>(context),
      behavior: HitTestBehavior.opaque,
      child: ScreenSideOffset.small(
        child: Post(eventReference: eventReference, showParent: showParent),
      ),
    );
  }
}
