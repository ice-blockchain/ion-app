import 'package:flutter/material.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/model/transaction_type.dart';

class TransactionListItemLeadingIcon extends StatelessWidget {
  const TransactionListItemLeadingIcon({
    super.key,
    required this.transactionType,
  });

  final TransactionType transactionType;

  Color getBorderColor(BuildContext context) {
    return switch (transactionType) {
      TransactionType.receive => context.theme.appColors.success,
      TransactionType.send => context.theme.appColors.onTerararyFill,
    };
  }

  Color getIconColor(BuildContext context) {
    return switch (transactionType) {
      TransactionType.receive => context.theme.appColors.secondaryBackground,
      TransactionType.send => context.theme.appColors.secondaryText,
    };
  }

  Color getBackgroundColor(BuildContext context) {
    return switch (transactionType) {
      TransactionType.receive => context.theme.appColors.success,
      TransactionType.send => context.theme.appColors.onSecondaryBackground,
    };
  }

  @override
  Widget build(BuildContext context) {
    final double size = 36.0.s;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: getBackgroundColor(context),
        borderRadius: BorderRadius.circular(10.0.s),
        border: Border.all(
          color: getBorderColor(context),
          width: 1.0.s,
        ),
      ),
      child: transactionType.iconAsset.icon(color: getIconColor(context)),
    );
  }
}
