// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/media_service/banuba_service.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

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
          // Launch video editor for the attached video
          final editedPath = await ref.read(editMediaProvider(attachedVideo).future);
          
          // If we reached here, Banuba returned successfully
          // Always update the video to ensure the controller reloads
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          attachedVideoNotifier.value = attachedVideo.copyWith(
            path: editedPath,
            name: 'edited_$timestamp',
          );
        } catch (e, stackTrace) {
          if (e is PlatformException && e.code == 'USER_CANCELLED') {
            // User cancelled editing - do nothing
          } else {
            Logger.log(
              'Failed to edit video',
              error: e,
              stackTrace: stackTrace,
            );
          }
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
