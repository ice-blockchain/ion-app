// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_request_sheet.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/settings_redirect_sheet.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

class VideoPreviewEditCover extends ConsumerWidget {
  const VideoPreviewEditCover({
    required this.attachedVideoNotifier,
    super.key,
  });

  final ValueNotifier<MediaFile?> attachedVideoNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PermissionAwareWidget(
      permissionType: Permission.photos,
      onGranted: () async {
        if (context.mounted) {
          final mediaFiles =
              await MediaPickerRoute(maxSelection: 1, mediaPickerType: MediaPickerType.image)
                  .push<List<MediaFile>>(context);
          if (mediaFiles != null && mediaFiles.isNotEmpty && attachedVideoNotifier.value != null) {
            final thumbPath = await ref.read(assetFilePathProvider(mediaFiles.first.path).future);
            attachedVideoNotifier.value = attachedVideoNotifier.value!.copyWith(thumb: thumbPath);
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
                  context.i18n.create_video_edit_cover,
                  style: context.theme.appTextThemes.body2.copyWith(
                    color: context.theme.appColors.secondaryBackground,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
