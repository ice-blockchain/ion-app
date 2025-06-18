// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/modal_sheets/simple_modal_sheet.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class RestoreFromCloudNoKeysAvailableModal extends ConsumerWidget {
  const RestoreFromCloudNoKeysAvailableModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SimpleModalSheet.alert(
      title: context.i18n.restore_from_cloud_identity_not_found_title,
      description: context.i18n.restore_from_cloud_identity_not_found_description,
      iconAsset: Assets.svgActionWalletKeyserror,
      button: ScreenSideOffset.small(
        child: Button(
          mainAxisSize: MainAxisSize.max,
          label: Text(context.i18n.button_close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
