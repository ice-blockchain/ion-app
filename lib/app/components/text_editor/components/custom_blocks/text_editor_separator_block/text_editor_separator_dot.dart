// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class TextEditorSeparatorDot extends StatelessWidget {
  const TextEditorSeparatorDot({
    required this.size,
    super.key,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.theme.appColors.onTertiaryBackground,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
