import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/generated/assets.gen.dart';

class BalanceActions extends StatelessWidget {
  const BalanceActions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 14.0.s),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Button.compact(
              leadingIcon: Assets.images.icons.iconButtonSend.icon(),
              label: Text(
                context.i18n.wallet_send,
              ),
              onPressed: () {},
            ),
          ),
          SizedBox(
            width: 12.0.s,
          ),
          Expanded(
            child: Button.compact(
              type: ButtonType.outlined,
              leadingIcon: Assets.images.icons.iconButtonReceive.icon(),
              label: Text(
                context.i18n.wallet_receive,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
