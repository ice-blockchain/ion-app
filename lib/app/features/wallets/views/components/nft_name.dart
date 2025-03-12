// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/card/rounded_card.dart';
import 'package:ion/app/extensions/extensions.dart';

class NftName extends StatelessWidget {
  const NftName({
    required this.name,
    required this.rank,
    super.key,
  });

  final String name;
  final String rank;

  @override
  Widget build(BuildContext context) {
    return RoundedCard.filled(
      padding: EdgeInsets.all(22.0.s),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 4.0.s),
            child: Text(
              name,
              maxLines: 2,
              style: context.theme.appTextThemes.subtitle.copyWith(
                color: context.theme.appColors.primaryText,
              ),
            ),
          ),
          Text(
            '#$rank',
            style: context.theme.appTextThemes.subtitle2.copyWith(
              color: context.theme.appColors.tertararyText,
            ),
          ),
        ],
      ),
    );
  }
}
