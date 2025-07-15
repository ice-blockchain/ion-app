// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ion/app/components/card/rounded_card.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class SelectedTopicPill extends StatelessWidget {
  const SelectedTopicPill({
    required this.categoryName,
    required this.onRemove,
    super.key,
  });

  final String categoryName;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return RoundedCard.filled(
      padding: EdgeInsetsDirectional.only(start: 12.s, end: 8.s, top: 8.s, bottom: 8.s),
      backgroundColor: context.theme.appColors.onSecondaryBackground,
      child: Row(
        children: [
          Text(categoryName, style: context.theme.appTextThemes.body),
          GestureDetector(
            onTap: onRemove,
            child: Padding(
              padding: EdgeInsetsDirectional.only(top: 2.s),
              child: SvgPicture.asset(Assets.svg.iconSheetClose),
            ),
          ),
        ],
      ),
    );
  }
}
