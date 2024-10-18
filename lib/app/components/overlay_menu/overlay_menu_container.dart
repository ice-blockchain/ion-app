// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class OverlayMenuContainer extends StatelessWidget {
  const OverlayMenuContainer({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
          ),
        ],
      ),
      child: Material(
        color: colors.secondaryBackground,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(16.0.s),
        child: child,
      ),
    );
  }
}
