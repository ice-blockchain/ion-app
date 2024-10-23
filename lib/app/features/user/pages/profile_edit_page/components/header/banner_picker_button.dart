// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ion/app/features/user/pages/components/header_action/header_action.dart';
import 'package:ion/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:ion/generated/assets.gen.dart';

class BannerPickerButton extends HookConsumerWidget {
  const BannerPickerButton({
    required this.pubkey,
    required this.onMediaSelected,
    super.key,
  });

  final ValueChanged<MediaFile?> onMediaSelected;
  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();

    return PermissionAwareWidget(
      permissionType: Permission.photos,
      onGranted: () {
        hideKeyboardAndCallOnce(
          callback: () async {
            if (context.mounted) {
              final mediaFiles =
                  await BannerPickerRoute(pubkey: pubkey).push<List<MediaFile>>(context);
              onMediaSelected(mediaFiles?.first);
            }
          },
        );
      },
      requestDialog: PermissionRequestSheet.fromType(context, Permission.photos),
      settingsDialog: SettingsRedirectSheet.fromType(context, Permission.photos),
      builder: (context, onPressed) {
        return HeaderAction(
          onPressed: onPressed,
          assetName: Assets.svg.iconProfileEditbg,
        );
      },
    );
  }
}
