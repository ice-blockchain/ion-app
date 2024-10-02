// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/modal_sheets/simple_modal_sheet.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class GalleryDeniedDialog extends StatelessWidget {
  const GalleryDeniedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleModalSheet.alert(
      title: context.i18n.gallery_permission_headline,
      description: context.i18n.gallery_no_access_title,
      iconAsset: Assets.svg.iconGalleryOpen,
      buttonText: context.i18n.button_go_to_settings,
      onPressed: () => Navigator.of(context).pop(true),
    );
  }
}
