// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/card/info_card.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class RecoverUserSuccessState extends StatelessWidget {
  const RecoverUserSuccessState({super.key});

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: AuthScrollContainer(
        title: context.i18n.backup_option_with_recovery_keys_title,
        icon: Assets.svg.iconLoginRestorekey.icon(size: 36.0.s),
        titleStyle: context.theme.appTextThemes.headline2,
        descriptionStyle: context.theme.appTextThemes.body2.copyWith(
          color: context.theme.appColors.secondaryText,
        ),
        children: [
          const Spacer(),
          ScreenSideOffset.small(
            child: InfoCard(
              iconAsset: Assets.svg.actionWalletSuccess2Fa,
              title: context.i18n.common_congratulations,
              description: context.i18n.two_fa_success_desc,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
