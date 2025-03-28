// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/config/providers/force_update_util_provider.c.dart';
import 'package:ion/app/features/core/model/app_update_type.dart';

class AppUpdateModal extends ConsumerWidget {
  const AppUpdateModal({
    required this.appUpdateType,
    super.key,
  });

  final AppUpdateType appUpdateType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(start: 30.0.s, end: 30.0.s, top: 30.0.s),
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
            onPressed: () async {
              if (appUpdateType == AppUpdateType.updateRequired) {
                final forceUpdateService = ref.read(forceUpdateServiceProvider);
                await forceUpdateService.handleForceUpdateRedirect();
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
