// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class SelectContainer extends StatelessWidget {
  const SelectContainer({
    required this.child,
    this.enabled = true,
    super.key,
  });

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 58.0.s),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: colors.strokeElements),
          borderRadius: BorderRadius.circular(16.0.s),
          color: colors.secondaryBackground,
        ),
        child: Row(
          children: [
            SizedBox(width: 16.0.s),
            Expanded(child: child),
            if (enabled) IconAsset(Assets.svgIconArrowDown),
            SizedBox(width: 16.0.s),
          ],
        ),
      ),
    );
  }
}
