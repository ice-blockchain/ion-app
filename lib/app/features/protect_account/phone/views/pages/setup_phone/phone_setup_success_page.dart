import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/card/info_card.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

class PhoneSetupSuccessPage extends StatelessWidget {
  const PhoneSetupSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return Column(
      children: [
        Spacer(),
        ScreenSideOffset.medium(
          child: InfoCard(
            iconAsset: Assets.images.icons.actionWalletConfirmphone,
            title: locale.common_successfully,
            description: locale.phone_success_description,
          ),
        ),
        Spacer(),
        ScreenSideOffset.large(
          child: Button(
            mainAxisSize: MainAxisSize.max,
            label: Text(locale.button_back_to_security),
            onPressed: () => SecureAccountOptionsRoute().replace(context),
          ),
        ),
      ],
    );
  }
}