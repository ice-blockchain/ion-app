// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class TransactionDetailsActions extends StatelessWidget {
  const TransactionDetailsActions({
    required this.onViewOnExplorer,
    required this.onShare,
    super.key,
  });

  final VoidCallback onViewOnExplorer;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Button(
            type: ButtonType.outlined,
            label: Text(
              context.i18n.transaction_details_view_on_explorer,
            ),
            mainAxisSize: MainAxisSize.max,
            leadingIcon: Assets.svg.iconButtonInternet.icon(),
            onPressed: onViewOnExplorer,
            backgroundColor: context.theme.appColors.tertararyBackground,
            borderColor: context.theme.appColors.onTerararyFill,
          ),
        ),
        SizedBox(
          width: 12.0.s,
        ),
        Button.icon(
          icon: Assets.svg.iconButtonShare.icon(),
          type: ButtonType.outlined,
          onPressed: onShare,
          backgroundColor: context.theme.appColors.tertararyBackground,
          borderColor: context.theme.appColors.onTerararyFill,
        ),
      ],
    );
  }
}
