// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/info_type.dart';
import 'package:ion/app/features/wallets/views/pages/info/info_modal.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class ListItemArrivalTime extends StatelessWidget {
  const ListItemArrivalTime({required this.formattedTime, super.key});

  final String formattedTime;

  @override
  Widget build(BuildContext context) {
    return ListItem.textWithIcon(
      title: GestureDetector(
        onTap: () {
          showSimpleBottomSheet<void>(
            context: context,
            child: const InfoModal(
              infoType: InfoType.arrivalTime,
            ),
          );
        },
        child: Row(
          children: [
            Text(context.i18n.wallet_arrival_time),
            SizedBox(width: 6.0.s),
            IconTheme(
              data: IconThemeData(
                size: 14.0.s,
              ),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  context.theme.appColors.secondaryText,
                  BlendMode.srcIn,
                ),
                child: IconAsset(Assets.svgIconBlockInformation, size: 14.0),
              ),
            ),
          ],
        ),
      ),
      value: formattedTime,
      icon: IconAsset(Assets.svgIconBlockTime, size: 16.0),
    );
  }
}
