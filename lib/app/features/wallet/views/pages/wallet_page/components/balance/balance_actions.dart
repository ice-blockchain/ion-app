import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/generated/assets.gen.dart';

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
      children: <Widget>[
        Expanded(
          child: Button.compact(
            leadingIcon: Assets.images.icons.iconButtonSend.icon(),
            label: Text(
              context.i18n.wallet_send,
            ),
            onPressed: onSend,
          ),
        ),
        SizedBox(
          width: UiSize.medium,
        ),
        Expanded(
          child: Button.compact(
            type: ButtonType.outlined,
            leadingIcon: Assets.images.icons.iconButtonReceive.icon(),
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
