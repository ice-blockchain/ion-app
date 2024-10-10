// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';

class PollAnswerItem extends StatelessWidget {
  const PollAnswerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.0.s,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.theme.appColors.onSecondaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
