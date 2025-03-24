// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/typedefs/typedefs.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({
    required this.eventReference,
    this.framedEventType = FramedEventType.quoted,
    this.onVideoTap,
    super.key,
  });

  final EventReference eventReference;

  final FramedEventType framedEventType;

  final OnVideoTapCallback? onVideoTap;

  @override
  Widget build(BuildContext context) {
    // TODO: process 20002 in the feed provider to fetch 10002

    return GestureDetector(
      onTap: () => PostDetailsRoute(eventReference: eventReference.encode()).push<void>(context),
      behavior: HitTestBehavior.opaque,
      child: Post(
        eventReference: eventReference,
        framedEventType: framedEventType,
        onVideoTap: onVideoTap,
      ),
    );
  }
}
