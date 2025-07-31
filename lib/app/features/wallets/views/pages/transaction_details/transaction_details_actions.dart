// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class TransactionDetailsActions extends StatelessWidget {
  const TransactionDetailsActions({
    required this.onViewOnExplorer,
    required this.onShare,
    this.disableExplorer = false,
    super.key,
  });

  final VoidCallback onViewOnExplorer;
  final VoidCallback onShare;
  final bool disableExplorer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Button(
            type: disableExplorer ? ButtonType.disabled : ButtonType.outlined,
            disabled: disableExplorer,
            label: Text(
              context.i18n.transaction_details_view_on_explorer,
            ),
            mainAxisSize: MainAxisSize.max,
            leadingIcon: Assets.svg.iconButtonInternet.icon(
              color: disableExplorer ? context.theme.appColors.onPrimaryAccent : null,
            ),
            onPressed: onViewOnExplorer,
            backgroundColor: disableExplorer ? null : context.theme.appColors.tertararyBackground,
            borderColor: disableExplorer ? null : context.theme.appColors.onTertararyFill,
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
          borderColor: context.theme.appColors.onTertararyFill,
        ),
      ],
    );
  }
}
