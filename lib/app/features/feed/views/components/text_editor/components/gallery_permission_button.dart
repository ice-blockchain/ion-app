import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/core/views/components/permission_aware_widget.dart';
import 'package:ice/app/features/core/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/services/media_service/media_service.dart';
import 'package:ice/generated/assets.gen.dart';

class GalleryPermissionButton extends HookConsumerWidget {
  const GalleryPermissionButton({
    required this.onMediaSelected,
    super.key,
  });

  final ValueChanged<List<MediaFile>?> onMediaSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();

    return PermissionAwareWidget(
      permissionType: AppPermissionType.photos,
      onGranted: () {
        hideKeyboardAndCallOnce(
          callback: () async {
            if (context.mounted) {
              final mediaFiles = await MediaPickerRoute().push<List<MediaFile>>(context);
              onMediaSelected(mediaFiles);
            }
          },
        );
      },
      requestDialog: PermissionRequestSheet.fromType(
        context,
        AppPermissionType.photos,
      ),
      settingsDialog: SettingsRedirectSheet.fromType(
        context,
        AppPermissionType.photos,
      ),
      builder: (context, onPressed) {
        return ActionsToolbarButton(
          icon: Assets.svg.iconGalleryOpen,
          onPressed: onPressed,
        );
      },
    );
  }
}
