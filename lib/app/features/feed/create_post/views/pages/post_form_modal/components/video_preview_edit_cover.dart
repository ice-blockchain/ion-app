// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
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
      onTap: () => context.pop(),
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
