// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/generated/assets.gen.dart';

class BalanceActions extends StatelessWidget {
  const BalanceActions({
    required this.onReceive,
    required this.onSend,
    super.key,
  });

  final VoidCallback onReceive;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Button.compact(
            leadingIcon: Assets.svg.iconButtonSend.icon(),
            label: Text(
              context.i18n.wallet_send,
            ),
            onPressed: onSend,
          ),
        ),
        SizedBox(
          width: 12.0.s,
        ),
        Expanded(
          child: Button.compact(
            type: ButtonType.outlined,
            leadingIcon: Assets.svg.iconButtonReceive.icon(),
            label: Text(
              context.i18n.wallet_receive,
            ),
            onPressed: onReceive,
          ),
        ),
      ],
    );
  }
}
