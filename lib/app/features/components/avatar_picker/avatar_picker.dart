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
import 'package:ion/app/features/user/providers/avatar_picker_notifier.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:ion/generated/assets.gen.dart';

class AvatarPicker extends HookConsumerWidget {
  const AvatarPicker({
    super.key,
    this.avatarUrl,
    this.pickMediaFile,
    this.title,
  });

  final String? avatarUrl;
  final Future<MediaFile?> Function()? pickMediaFile;
  final String? title;

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
          child: PermissionAwareWidget(
            permissionType: Permission.photos,
            onGranted: () {
              if (avatarPickerState is! AvatarPickerStatePicked) {
                ref.read(avatarPickerNotifierProvider.notifier).pick(
                      cropUiSettings:
                          ref.read(mediaServiceProvider).buildCropImageUiSettings(context),
                      pickMediaFile: () async {
                        final mediaFiles = await showSimpleBottomSheet<List<MediaFile>>(
                          context: context,
                          child: MediaPickerPage(
                            maxSelection: 1,
                            isBottomSheet: true,
                            title: title,
                          ),
                        );
                        return mediaFiles?.first;
                      },
                    );
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
                  width: 36.0.s,
                  height: 36.0.s,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.theme.appColors.primaryAccent,
                  ),
                  child: avatarPickerState is AvatarPickerStatePicked
                      ? const IONLoadingIndicator()
                      : Assets.svg.iconLoginCamera.icon(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
