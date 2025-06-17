// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/modal_sheets/simple_modal_sheet.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/permissions/data/models/models.dart';
import 'package:ion/app/features/core/permissions/providers/permissions_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class CloudDisabledModal extends ConsumerWidget {
  const CloudDisabledModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;
    final option = Platform.isIOS ? locale.backup_icloud : locale.backup_google_drive;
    final buttonMinimalSize = Size(56.0.s, 56.0.s);

    return SimpleModalSheet.alert(
      title: context.i18n.backup_cloud_disabled_title(option),
      description: context.i18n.backup_cloud_disabled_description(option),
      iconAsset: Assets.svgactionCreatepostLogout,
      button: ScreenSideOffset.small(
        child: Row(
          children: [
            Expanded(
              child: Button.compact(
                mainAxisSize: MainAxisSize.max,
                onPressed: () => Navigator.of(context).pop(),
                label: Text(context.i18n.button_cancel),
                type: ButtonType.outlined,
                minimumSize: buttonMinimalSize,
              ),
            ),
            SizedBox(width: 16.0.s),
            Expanded(
              child: Button(
                mainAxisSize: MainAxisSize.max,
                label: Text(context.i18n.settings_title),
                minimumSize: buttonMinimalSize,
                onPressed: () =>
                    ref.read(permissionStrategyProvider(Permission.cloud)).openSettings(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
