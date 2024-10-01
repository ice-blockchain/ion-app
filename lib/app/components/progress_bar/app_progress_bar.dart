// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({
    required this.progressValue,
    super.key,
  });
  final double progressValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 3.0.s,
      child: LinearProgressIndicator(
        value: progressValue,
        backgroundColor: context.theme.appColors.secondaryBackground,
        valueColor: AlwaysStoppedAnimation<Color>(context.theme.appColors.primaryAccent),
      ),
    );
  }
}
