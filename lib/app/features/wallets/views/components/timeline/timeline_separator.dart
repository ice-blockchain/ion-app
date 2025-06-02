// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class TimelineSeparator extends StatelessWidget {
  const TimelineSeparator({
    super.key,
    this.color = Colors.transparent,
  });

  final Color color;

  static double get separatorWidth => 0.5.s;
  static double get separatorHeight => 18.0.s;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: separatorWidth,
      height: separatorHeight,
      color: color,
    );
  }
}
