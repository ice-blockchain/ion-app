// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/user/pages/pull_right_menu_page/components/footer/footer_action.dart';
import 'package:ion/generated/assets.gen.dart';

class Footer extends StatelessWidget {
  const Footer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0.s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FooterAction(
              onPressed: () {},
              icon: Assets.svg.iconWalletSettings.icon(),
              label: context.i18n.profile_privacy,
            ),
            FooterAction(
              onPressed: () {},
              icon: Assets.svg.iconProfileHelp.icon(),
              label: context.i18n.profile_help,
            ),
          ],
        ),
      ),
    );
  }
}
