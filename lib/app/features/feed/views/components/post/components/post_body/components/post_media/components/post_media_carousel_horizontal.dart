// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/components/post_media/components/post_media_item.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/typedefs/typedefs.dart';

class PostMediaCarouselHorizontal extends HookConsumerWidget {
  const PostMediaCarouselHorizontal({
    required this.media,
    required this.aspectRatio,
    required this.eventReference,
    this.framedEventReference,
    this.onVideoTap,
    super.key,
  });

  final List<MediaAttachment> media;
  final double aspectRatio;
  final EventReference eventReference;
  final EventReference? framedEventReference;
  final OnVideoTapCallback? onVideoTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: aspectRatio,
          child: PageView(
            onPageChanged: (index) => currentIndex.value = index,
            children: [
              for (int i = 0; i < media.length; i++)
                ScreenSideOffset.small(
                  child: PostMediaItem(
                    mediaItem: media[i],
                    mediaIndex: i,
                    videoIndex: media[i].mediaType == MediaType.video
                        ? media.take(i + 1).where((m) => m.mediaType == MediaType.video).length - 1
                        : 0,
                    aspectRatio: aspectRatio,
                    eventReference: eventReference,
                    onVideoTap: onVideoTap,
                    framedEventReference: framedEventReference,
                  ),
                ),
            ],
          ),
        ),
        PositionedDirectional(
          top: 8.0.s,
          end: 24.0.s,
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
