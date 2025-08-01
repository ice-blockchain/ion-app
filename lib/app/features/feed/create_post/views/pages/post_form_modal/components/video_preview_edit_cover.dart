// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/constants/video_constants.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/media_service/banuba_service.r.dart';
import 'package:ion/app/services/media_service/media_service.m.dart';

class VideoPreviewEditCover extends ConsumerWidget {
  const VideoPreviewEditCover({
    required this.attachedVideoNotifier,
    super.key,
  });

  final ValueNotifier<MediaFile?> attachedVideoNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        final attachedVideo = attachedVideoNotifier.value;
        if (attachedVideo == null) return;

        try {
          final editedMedia = await ref.read(
            editMediaProvider(
              attachedVideo,
              maxVideoDuration: VideoConstants.feedVideoMaxDuration,
            ).future,
          );

          if (editedMedia != null && editedMedia.path != attachedVideo.path) {
            final timestamp = DateTime.now().millisecondsSinceEpoch;
            attachedVideoNotifier.value = attachedVideo.copyWith(
              path: editedMedia.path,
              name: 'edited_$timestamp',
              thumb: editedMedia.thumb,
            );
          }
        } catch (e, stackTrace) {
          Logger.log(
            'Video editing failed or cancelled',
            error: e,
            stackTrace: stackTrace,
          );
        }
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.theme.appColors.backgroundSheet,
          borderRadius: BorderRadius.circular(16.0.s),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8.0.s,
              vertical: 4.0.s,
            ),
            child: Text(
              context.i18n.button_edit,
              style: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.secondaryBackground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
