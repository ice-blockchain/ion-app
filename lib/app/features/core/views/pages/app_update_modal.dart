// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/app_update_type.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';

class AppUpdateModal extends StatelessWidget {
  const AppUpdateModal({
    required this.appUpdateType,
    super.key,
  });

  final AppUpdateType appUpdateType;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 30.0.s, right: 30.0.s, top: 30.0.s),
          child: InfoCard(
            iconAsset: appUpdateType.iconAsset,
            title: appUpdateType.getTitle(context),
            description: appUpdateType.getDesc(context),
          ),
        ),
        SizedBox(height: 24.0.s),
        ScreenSideOffset.small(
          child: Button(
            leadingIcon: appUpdateType.buttonIconAsset.icon(
              color: context.theme.appColors.onPrimaryAccent,
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              if (appUpdateType == AppUpdateType.updateRequired) {
                showSimpleBottomSheet<void>(
                  context: context,
                  child: const AppUpdateModal(
                    appUpdateType: AppUpdateType.upToDate,
                  ),
                );
              }
            },
            label: Text(appUpdateType.getActionTitle(context)),
            mainAxisSize: MainAxisSize.max,
          ),
        ),
        ScreenBottomOffset(),
      ],
    );
  }
}
