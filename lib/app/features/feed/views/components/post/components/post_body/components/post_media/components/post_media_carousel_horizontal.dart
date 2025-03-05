// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/components/post_media/components/post_media_item.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/uuid/uuid.dart';

class PostMediaCarouselHorizontal extends HookConsumerWidget {
  const PostMediaCarouselHorizontal({
    required this.media,
    required this.aspectRatio,
    required this.eventReference,
    super.key,
  });

  final List<MediaAttachment> media;
  final double aspectRatio;
  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);
    final heroTag = useMemoized(generateUuid);

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: aspectRatio,
          child: PageView(
            onPageChanged: (index) => currentIndex.value = index,
            children: [
              for (int i = 0; i < media.length; i++)
                GestureDetector(
                  onTap: () => FullscreenMediaRoute(
                    eventReference: eventReference.encode(),
                    initialMediaIndex: i,
                    heroTag: heroTag,
                  ).push<void>(context),
                  child: ScreenSideOffset.small(
                    child: PostMediaItem(
                      mediaItem: media[i],
                      mediaIndex: i,
                      aspectRatio: aspectRatio,
                      eventReference: eventReference,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          top: 8.0.s,
          right: 8.0.s,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6.0.s)),
              color: context.theme.appColors.backgroundSheet,
            ),
            padding: EdgeInsets.symmetric(horizontal: 4.0.s, vertical: 1.0.s),
            child: Text(
              '${currentIndex.value + 1}/${media.length}',
              style: context.theme.appTextThemes.caption.copyWith(
                color: context.theme.appColors.primaryBackground,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
