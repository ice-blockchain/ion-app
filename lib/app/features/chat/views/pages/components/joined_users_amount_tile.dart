// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class JoinedUsersAmountTile extends StatelessWidget {
  const JoinedUsersAmountTile({
    required this.amount,
    super.key,
  });

  final int amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Assets.svg.iconChannelMembers.icon(
          size: 10.0.s,
          color: context.theme.appColors.quaternaryText,
        ),
        SizedBox(
          width: 3.0.s,
        ),
        Text(
          amount.toString(),
          style: context.theme.appTextThemes.caption.copyWith(
            color: context.theme.appColors.quaternaryText,
          ),
        ),
      ],
    );
  }
}
