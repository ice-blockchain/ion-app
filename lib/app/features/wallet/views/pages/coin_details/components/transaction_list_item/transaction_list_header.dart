import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/views/pages/coin_details/components/transaction_list_item/constants.dart';
import 'package:ice/app/features/wallet/views/pages/coin_details/components/transaction_list_item/transaction_list_header_item.dart';

class TransactionListHeader extends StatelessWidget {
  const TransactionListHeader({
    required this.selectedNetworkType,
    required this.onNetworkTypeSelect,
    super.key,
  });

  final NetworkType selectedNetworkType;
  final void Function(NetworkType) onNetworkTypeSelect;

  static const List<NetworkType> networkTypeValues = NetworkType.values;

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
          final networkType = networkTypeValues[index];
          return TransactionListHeaderItem(
            isSelected: networkType == selectedNetworkType,
            networkType: networkType,
            onPress: () => onNetworkTypeSelect(networkType),
          );
        },
      ),
    );
  }
}
