// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';

class TransactionSectionHeader extends StatelessWidget {
  const TransactionSectionHeader({
    required this.date,
    super.key,
  });

  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: 10.0.s,
      ),
      child: Text(
        date,
        style: context.theme.appTextThemes.caption3.copyWith(
          color: context.theme.appColors.tertararyText,
        ),
      ),
    );
  }
}
