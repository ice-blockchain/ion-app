// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';

class FeedListSeparator extends StatelessWidget {
  FeedListSeparator({
    super.key,
    double? height,
  }) : height = height ?? 12.0.s;

  final double height;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.theme.appColors.primaryBackground,
      child: ConstrainedBox(
        constraints: BoxConstraints.tight(Size.fromHeight(height)),
      ),
    );
  }
}
