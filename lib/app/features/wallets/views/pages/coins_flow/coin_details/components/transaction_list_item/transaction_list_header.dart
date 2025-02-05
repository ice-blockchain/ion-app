// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/wallets/model/network.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/components/transaction_list_item/constants.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/components/transaction_list_item/transaction_list_header_item.dart';

class TransactionListHeader extends StatelessWidget {
  const TransactionListHeader({
    required this.selectedNetwork,
    required this.onNetworkTypeSelect,
    super.key,
  });

  final Network selectedNetwork;
  final void Function(Network) onNetworkTypeSelect;

  static const List<Network> networkTypeValues = Network.values;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: TransactionListConstants.headerItemHeight +
          TransactionListConstants.headerPaddingBottom +
          TransactionListConstants.headerPaddingTop,
      child: ListView.separated(
        padding: EdgeInsets.only(
          left: ScreenSideOffset.defaultSmallMargin,
          right: ScreenSideOffset.defaultSmallMargin,
          top: TransactionListConstants.headerPaddingTop,
          bottom: TransactionListConstants.headerPaddingBottom,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: networkTypeValues.length,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 6.0.s);
        },
        itemBuilder: (BuildContext context, int index) {
          final network = networkTypeValues[index];
          return TransactionListHeaderItem(
            isSelected: network == selectedNetwork,
            network: network,
            onPress: () => onNetworkTypeSelect(network),
          );
        },
      ),
    );
  }
}
