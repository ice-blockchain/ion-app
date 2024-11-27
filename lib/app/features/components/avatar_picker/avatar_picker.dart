// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_page.dart';
import 'package:ion/app/features/user/providers/avatar_processor_notifier.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:ion/generated/assets.gen.dart';

class AvatarPicker extends HookConsumerWidget {
  const AvatarPicker({
    super.key,
    this.avatarUrl,
    this.title,
    this.iconSize,
    this.iconBackgroundSize,
    this.avatarSize,
  });

  final String? avatarUrl;
  final double? avatarSize;
  final double? iconSize;
  final double? iconBackgroundSize;
  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarPickerState = ref.watch(avatarProcessorNotifierProvider);

    final avatarFile = avatarPickerState.whenOrNull(
      cropped: (file) => file,
      processed: (file) => file,
    );

    ref.displayErrorsForState<AvatarProcessorStateError>(avatarProcessorNotifierProvider);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Avatar(
          size: avatarSize ?? 100.0.s,
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
          child: PermissionAwareWidget(
            permissionType: Permission.photos,
            onGranted: () async {
              if (avatarPickerState is AvatarProcessorStateInitial ||
                  avatarPickerState is AvatarProcessorStateError) {
                final mediaFiles = await showSimpleBottomSheet<List<MediaFile>>(
                  context: context,
                  child: MediaPickerPage(
                    maxSelection: 1,
                    isBottomSheet: true,
                    title: title,
                  ),
                );
                if (mediaFiles != null && context.mounted) {
                  await ref.read(avatarProcessorNotifierProvider.notifier).process(
                        assetId: mediaFiles.first.path,
                        cropUiSettings:
                            ref.read(mediaServiceProvider).buildCropImageUiSettings(context),
                      );
                }
              }
            },
            requestDialog: const PermissionRequestSheet(
              permission: Permission.photos,
            ),
            settingsDialog: SettingsRedirectSheet.fromType(context, Permission.photos),
            builder: (context, onPressed) {
              return GestureDetector(
                onTap: onPressed,
                child: Container(
                  width: iconBackgroundSize ?? 36.0.s,
                  height: iconBackgroundSize ?? 36.0.s,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.theme.appColors.primaryAccent,
                  ),
                  child: avatarPickerState is AvatarProcessorStateCropped
                      ? const IONLoadingIndicator()
                      : Assets.svg.iconLoginCamera.icon(size: iconSize),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
