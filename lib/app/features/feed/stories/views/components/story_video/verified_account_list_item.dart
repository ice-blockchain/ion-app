// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class VerifiedAccountListItem extends StatelessWidget {
  const VerifiedAccountListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListItem(
      backgroundColor: context.theme.appColors.onPrimaryAccent,
      leading: Assets.svg.iconPostVerifyaccount.icon(
        color: context.theme.appColors.primaryAccent,
      ),
      title: Text(
        context.i18n.visibility_settings_verified_accounts,
        style: context.theme.appTextThemes.caption.copyWith(
          color: context.theme.appColors.primaryAccent,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 8.0.s),
      trailing: Assets.svg.iconArrowRight.icon(
        color: context.theme.appColors.primaryAccent,
      ),
    );
  }
}
