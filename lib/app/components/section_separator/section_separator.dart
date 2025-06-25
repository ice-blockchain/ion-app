// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';

class SectionSeparator extends StatelessWidget {
  const SectionSeparator({
    super.key,
    this.height,
  });

  final double? height;

  static const double _defaultHeight = 4;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.theme.appColors.primaryBackground,
      child: ConstrainedBox(
        constraints: BoxConstraints.tight(
          Size.fromHeight(height ?? _defaultHeight.s),
        ),
      ),
    );
  }
}
