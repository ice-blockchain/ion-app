// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/card/rounded_card.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class WarningCard extends StatelessWidget {
  const WarningCard({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return RoundedCard.outlined(
      padding: EdgeInsets.symmetric(horizontal: 10.0.s),
      child: ListItem(
        contentPadding: EdgeInsets.zero,
        borderRadius: BorderRadius.all(Radius.circular(16.0.s)),
        leading: Assets.svg.iconReport.icon(
          size: 20.0.s,
          color: context.theme.appColors.attentionRed,
        ),
        title: Text(
          text,
          style: context.theme.appTextThemes.caption.copyWith(
            color: context.theme.appColors.attentionRed,
          ),
          maxLines: 3,
        ),
      ),
    );
  }
}
