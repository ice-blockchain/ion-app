// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:photo_manager/photo_manager.dart';

class ManageAccessBanner extends StatelessWidget {
  const ManageAccessBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.theme.appColors.tertararyBackground,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.0.s,
          horizontal: 16.0.s,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                context.i18n.gallery_access_description,
                style: context.theme.appTextThemes.caption2,
              ),
            ),
            Button(
              onPressed: PhotoManager.openSetting,
              type: ButtonType.outlined,
              tintColor: context.theme.appColors.primaryAccent,
              leadingIcon: Assets.svg.iconButtonManagecoin.icon(
                color: context.theme.appColors.primaryAccent,
                size: 16.0.s,
              ),
              label: Text(
                context.i18n.gallery_manage,
                style: context.theme.appTextThemes.caption.copyWith(
                  color: context.theme.appColors.primaryAccent,
                ),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(87.0.s, 28.0.s),
                padding: EdgeInsets.symmetric(horizontal: 15.0.s),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
