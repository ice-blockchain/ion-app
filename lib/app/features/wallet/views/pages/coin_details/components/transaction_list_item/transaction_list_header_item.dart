import 'package:flutter/material.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/views/pages/coin_details/components/transaction_list_item/constants.dart';

class TransactionListHeaderItem extends StatelessWidget {
  const TransactionListHeaderItem({
    required this.networkType,
    required this.isSelected,
    required this.onPress,
    super.key,
  });

  final NetworkType networkType;
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
            children: <Widget>[
              networkType.iconAsset.icon(size: 16.0.s),
              SizedBox(
                width: 6.0.s,
              ),
              Text(
                networkType.getDisplayName(context),
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
