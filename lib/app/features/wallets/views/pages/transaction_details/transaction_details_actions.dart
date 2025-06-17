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
            leadingIcon: disableExplorer 
              ? IconAssetColored(Assets.svgIconButtonInternet, color: context.theme.appColors.onPrimaryAccent)
              : IconAsset(Assets.svgIconButtonInternet),
            onPressed: onViewOnExplorer,
            backgroundColor: disableExplorer ? null : context.theme.appColors.tertararyBackground,
            borderColor: disableExplorer ? null : context.theme.appColors.onTerararyFill,
          ),
        ),
        SizedBox(
          width: 12.0.s,
        ),
        Button.icon(
          icon: IconAsset(Assets.svgIconButtonShare),
          type: ButtonType.outlined,
          onPressed: onShare,
          backgroundColor: context.theme.appColors.tertararyBackground,
          borderColor: context.theme.appColors.onTerararyFill,
        ),
      ],
    );
  }
}
