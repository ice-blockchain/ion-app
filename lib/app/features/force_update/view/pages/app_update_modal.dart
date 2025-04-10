// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/force_update/model/app_update_type.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/services/ui_event_queue/ui_event_queue_notifier.c.dart';

class ShowAppUpdateModalEvent extends UiEvent {
  const ShowAppUpdateModalEvent();

  static bool shown = false;

  @override
  void performAction(BuildContext context) {
    if (!shown) {
      shown = true;
      showSimpleBottomSheet<void>(
        context: context,
        isDismissible: false,
        child: const AppUpdateModal(
          appUpdateType: AppUpdateType.updateRequired,
        ),
      ).then((_) => shown = false);
    }
  }
}

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
                //TODO:add
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
