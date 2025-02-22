// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class ListItemArrivalTime extends StatelessWidget {
  const ListItemArrivalTime({required this.formattedTime, super.key});

  final String formattedTime;

  @override
  Widget build(BuildContext context) {
    return ListItem.textWithIcon(
      title: Row(
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
              child: Assets.svg.iconBlockInformation.icon(size: 14.0.s),
            ),
          ),
        ],
      ),
      value: formattedTime,
      icon: Assets.svg.iconBlockTime.icon(
        size: 16.0.s,
      ),
    );
  }
}
