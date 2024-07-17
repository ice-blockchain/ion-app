import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class SendFundsSuccessSendButton extends StatelessWidget {
  const SendFundsSuccessSendButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: Column(
        children: [
          Button(
            label: Text(context.i18n.wallet_transaction_details),
            leadingIcon: Assets.images.icons.iconButtonDetails.icon(),
            mainAxisSize: MainAxisSize.max,
            onPressed: () {},
          ),
          SizedBox(height: 12.0.s),
          Row(
            children: [
              Expanded(
                child: Button(
                  type: ButtonType.outlined,
                  onPressed: () {},
                  leadingIcon: Assets.images.icons.iconButtonShare.icon(),
                  label: Text(context.i18n.wallet_share),
                ),
              ),
              SizedBox(width: 13.0.s),
              Expanded(
                child: Button(
                  type: ButtonType.outlined,
                  onPressed: () => Navigator.pop(context),
                  leadingIcon: Assets.images.icons.iconSheetClose.icon(
                    color: context.theme.appColors.secondaryText,
                  ),
                  label: Text(context.i18n.button_close),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
