// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/generated/assets.gen.dart';

class PermissionRequestSheet extends StatelessWidget {
  const PermissionRequestSheet({
    required this.title,
    required this.description,
    required this.iconAsset,
    super.key,
  });

  factory PermissionRequestSheet.fromType(
    BuildContext context,
    Permission permissionType,
  ) {
    if (permissionType == Permission.photos) {
      return PermissionRequestSheet(
        title: context.i18n.photo_library_require_access_title,
        description: context.i18n.photo_library_require_access_description,
        iconAsset: Assets.svg.walletIconWalletGelleryperm,
      );
    } else if (permissionType == Permission.camera) {
      return PermissionRequestSheet(
        title: context.i18n.camera_require_access_title,
        description: context.i18n.camera_require_access_description,
        iconAsset: Assets.svg.walletIconWalletCamera,
      );
    }

    throw Exception('UI is not implemented for the permission type $permissionType');
  }

  final String title;
  final String description;
  final String iconAsset;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 42.0.s),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.s),
          child: InfoCard(
            iconAsset: iconAsset,
            title: title,
            description: description,
          ),
        ),
        SizedBox(height: 32.0.s),
        ScreenSideOffset.small(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Button(
                  mainAxisSize: MainAxisSize.max,
                  label: Text(context.i18n.button_dont_allow),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ),
              SizedBox(width: 16.0.s),
              Flexible(
                child: Button(
                  mainAxisSize: MainAxisSize.max,
                  label: Text(context.i18n.button_allow),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ),
            ],
          ),
        ),
        ScreenBottomOffset(),
      ],
    );
  }
}
