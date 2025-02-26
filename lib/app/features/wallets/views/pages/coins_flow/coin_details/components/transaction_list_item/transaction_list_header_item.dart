// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/views/components/network_icon_widget.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/components/transaction_list_item/constants.dart';

class TransactionListHeaderItem extends StatelessWidget {
  const TransactionListHeaderItem({
    required this.network,
    required this.isSelected,
    required this.onPress,
    super.key,
  });

  final NetworkData network;
  final bool isSelected;
  final VoidCallback onPress;

  Color _getBorderColor(BuildContext context) {
    return isSelected
        ? context.theme.appColors.primaryAccent
        : context.theme.appColors.onTerararyFill;
  }

  Color _getTextColor(BuildContext context) {
    return isSelected
        ? context.theme.appColors.primaryText
        : context.theme.appColors.onTertararyBackground;
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(8.0.s);
    return Material(
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onPress,
        borderRadius: borderRadius,
        child: Ink(
          height: TransactionListConstants.headerItemHeight,
          decoration: BoxDecoration(
            color: context.theme.appColors.tertararyBackground,
            borderRadius: borderRadius,
            border: Border.all(
              color: _getBorderColor(context),
              width: 1.0.s,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 5.0.s,
          ),
          child: Row(
            children: [
              NetworkIconWidget(
                size: 16.0.s,
                imageUrl: network.image,
              ),
              SizedBox(
                width: 6.0.s,
              ),
              Text(
                network.displayName,
                style: context.theme.appTextThemes.body2.copyWith(
                  color: _getTextColor(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
