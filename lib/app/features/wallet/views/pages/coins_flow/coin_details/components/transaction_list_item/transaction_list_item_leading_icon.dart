// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallet/model/transaction_type.dart';

class TransactionListItemLeadingIcon extends StatelessWidget {
  const TransactionListItemLeadingIcon({
    required this.transactionType,
    super.key,
  });

  final TransactionType transactionType;

  Color _getBorderColor(BuildContext context) {
    return switch (transactionType) {
      TransactionType.receive => context.theme.appColors.success,
      TransactionType.send => context.theme.appColors.onTerararyFill,
    };
  }

  Color _getIconColor(BuildContext context) {
    return switch (transactionType) {
      TransactionType.receive => context.theme.appColors.secondaryBackground,
      TransactionType.send => context.theme.appColors.secondaryText,
    };
  }

  Color _getBackgroundColor(BuildContext context) {
    return switch (transactionType) {
      TransactionType.receive => context.theme.appColors.success,
      TransactionType.send => context.theme.appColors.onSecondaryBackground,
    };
  }

  @override
  Widget build(BuildContext context) {
    final size = 36.0.s;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(10.0.s),
        border: Border.all(
          color: _getBorderColor(context),
          width: 1.0.s,
        ),
      ),
      child: transactionType.iconAsset.icon(color: _getIconColor(context)),
    );
  }
}
