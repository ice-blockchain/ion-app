// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/avatar_picker_notifier.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:ion/generated/assets.gen.dart';

class AvatarPicker extends ConsumerWidget {
  const AvatarPicker({
    super.key,
    this.avatarUrl,
  });

  final String? avatarUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarPickerState = ref.watch(avatarPickerNotifierProvider);

    final avatarFile = avatarPickerState.whenOrNull(
      picked: (file) => file,
      compressed: (file) => file,
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Avatar(
          size: 100.0.s,
          borderRadius: BorderRadius.circular(20.0.s),
          imageUrl: avatarFile == null ? avatarUrl : null,
          imageWidget: avatarFile != null
              ? Image.file(File(avatarFile.path))
              : avatarUrl == null
                  ? Assets.svg.userPhotoArea.icon(size: 100.0.s)
                  : null,
        ),
        Positioned(
          bottom: -6.0.s,
          right: 0,
          child: GestureDetector(
            onTap: avatarPickerState is AvatarPickerStatePicked
                ? null
                : () => ref.read(avatarPickerNotifierProvider.notifier).pick(
                      cropUiSettings:
                          ref.read(mediaServiceProvider).buildCropImageUiSettings(context),
                    ),
            child: Container(
              width: 36.0.s,
              height: 36.0.s,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.theme.appColors.primaryAccent,
              ),
              child: avatarPickerState is AvatarPickerStatePicked
                  ? const IonLoadingIndicator()
                  : Assets.svg.iconLoginCamera.icon(),
            ),
          ),
        ),
      ],
    );
  }
}
