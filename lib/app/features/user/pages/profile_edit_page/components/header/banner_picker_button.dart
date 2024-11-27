// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_page.dart';
import 'package:ion/app/features/user/pages/components/header_action/header_action.dart';
import 'package:ion/app/features/user/providers/banner_picker_notifier.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:ion/generated/assets.gen.dart';

class BannerPickerButton extends ConsumerWidget {
  const BannerPickerButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBannerLoading = ref
        .watch(bannerPickerNotifierProvider.select((state) => state is BannerPickerStateCropped));

    ref.displayErrorsForState<BannerPickerStateError>(bannerPickerNotifierProvider);

    return PermissionAwareWidget(
      permissionType: Permission.photos,
      onGranted: () async {
        if (context.mounted) {
          final mediaFiles = await showSimpleBottomSheet<List<MediaFile>>(
            context: context,
            child: const MediaPickerPage(
              maxSelection: 1,
              isBottomSheet: true,
            ),
          );
          if (mediaFiles != null && context.mounted) {
            await ref.read(bannerPickerNotifierProvider.notifier).process(
                  assetId: mediaFiles.first.path,
                  cropUiSettings: ref.read(mediaServiceProvider).buildCropImageUiSettings(context),
                );
          }
        }
      },
      requestDialog: const PermissionRequestSheet(
        permission: Permission.photos,
      ),
      settingsDialog: SettingsRedirectSheet.fromType(context, Permission.photos),
      builder: (context, onPressed) {
        return HeaderAction(
          onPressed: onPressed,
          loading: isBannerLoading,
          assetName: Assets.svg.iconProfileEditbg,
        );
      },
    );
  }
}
