import 'package:flutter/material.dart';
import 'package:ice/app/components/card/rounded_card.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/authenticator/components/copy_key_card.dart';
import 'package:ice/generated/assets.gen.dart';

class AuthenticatorInstructionsPage extends StatelessWidget {
  const AuthenticatorInstructionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return ScreenSideOffset.large(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          CopyKeyCard(),
          Spacer(),
          RoundedCard.outlined(
            padding: EdgeInsets.symmetric(horizontal: 10.0.s),
            child: ListItem(
              contentPadding: EdgeInsets.zero,
              backgroundColor: context.theme.appColors.secondaryBackground,
              borderRadius: BorderRadius.all(
                Radius.circular(16.0.s),
              ),
              leading: Assets.images.icons.iconReport.icon(
                size: 20.0.s,
                color: context.theme.appColors.attentionRed,
              ),
              title: Text(
                locale.warning_authenticator_setup,
                style: context.theme.appTextThemes.caption.copyWith(
                  color: context.theme.appColors.attentionRed,
                ),
                maxLines: 3,
              ),
            ),
          ),
          SizedBox(height: 24.0.s),
        ],
      ),
    );
  }
}
