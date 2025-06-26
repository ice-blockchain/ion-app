// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/wallets/model/network_selector_data.f.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/components/transaction_list_item/constants.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/components/transaction_list_item/transaction_list_header_item.dart';

class TransactionListHeader extends StatelessWidget {
  const TransactionListHeader({
    required this.items,
    required this.selected,
    required this.onNetworkTypeSelect,
    super.key,
  });

  final SelectedNetworkItem selected;
  final List<SelectedNetworkItem> items;
  final void Function(SelectedNetworkItem) onNetworkTypeSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: TransactionListConstants.headerItemHeight +
          TransactionListConstants.headerPaddingBottom +
          TransactionListConstants.headerPaddingTop,
      child: ListView.separated(
        padding: EdgeInsetsDirectional.only(
          start: ScreenSideOffset.defaultSmallMargin,
          end: ScreenSideOffset.defaultSmallMargin,
          top: TransactionListConstants.headerPaddingTop,
          bottom: TransactionListConstants.headerPaddingBottom,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (BuildContext context, int index) => SizedBox(width: 6.0.s),
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];
          return TransactionListHeaderItem(
            item: item,
            isSelected: item == selected,
            onPress: () => onNetworkTypeSelect(item),
          );
        },
      ),
    );
  }
}
