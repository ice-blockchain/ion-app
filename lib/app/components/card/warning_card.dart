// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/card/rounded_card.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class WarningCard extends StatelessWidget {
  const WarningCard({
    required this.text,
    this.borderColor,
    this.backgroundColor,
    super.key,
  });

  final String text;
  final Color? borderColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return RoundedCard.outlined(
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      padding: EdgeInsets.symmetric(horizontal: 10.0.s),
      child: ListItem(
        backgroundColor: backgroundColor,
        contentPadding: EdgeInsets.zero,
        borderRadius: BorderRadius.all(Radius.circular(16.0.s)),
        leading: Assets.svgIconReport.icon(
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
