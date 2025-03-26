// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/generated/assets.gen.dart';

class GalleryPermissionButton extends ConsumerWidget {
  const GalleryPermissionButton({
    required this.mediaPickerType,
    required this.onMediaSelected,
    required this.maxSelection,
    super.key,
  });

  final MediaPickerType mediaPickerType;
  final ValueChanged<List<MediaFile>?> onMediaSelected;
  final int? maxSelection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PermissionAwareWidget(
      permissionType: Permission.photos,
      requestId: 'gallery_permission_button',
      onGranted: () async {
        if (context.mounted) {
          final mediaFiles = await MediaPickerRoute(
            mediaPickerType: mediaPickerType,
            maxSelection: maxSelection,
          ).push<List<MediaFile>>(context);
          onMediaSelected(mediaFiles);
        }
      },
      requestDialog: const PermissionRequestSheet(
        permission: Permission.photos,
      ),
      settingsDialog: SettingsRedirectSheet.fromType(context, Permission.photos),
      builder: (context, onPressed) {
        return ActionsToolbarButton(
          icon: Assets.svg.iconGalleryOpen,
          onPressed: onPressed,
        );
      },
    );
  }
}
