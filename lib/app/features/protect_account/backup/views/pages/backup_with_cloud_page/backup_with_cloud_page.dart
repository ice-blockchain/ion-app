// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ion/app/features/protect_account/backup/views/pages/backup_with_cloud_page/components/backup_with_cloud_password_input_body.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class BackupWithCloudPage extends StatelessWidget {
  const BackupWithCloudPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;
    final cloudOption = Platform.isIOS ? locale.backup_icloud : locale.backup_google_drive;

    return SheetContent(
      topPadding: 0,
      body: KeyboardDismissOnTap(
        child: AuthScrollContainer(
          title: locale.backup_option_with(cloudOption),
          description: locale.backup_cloud_page_description(cloudOption),
          icon: IconAsset(Assets.svgIconLoginRestorekey, size: 36.0),
          children: const [
            Expanded(
              child: BackupWithCloudPasswordInputBody(),
            ),
          ],
        ),
      ),
    );
  }
}
