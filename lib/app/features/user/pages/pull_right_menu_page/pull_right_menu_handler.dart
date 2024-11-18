// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';

class PullRightMenuHandler extends StatelessWidget {
  const PullRightMenuHandler({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.velocity.pixelsPerSecond.dx > 100 &&
            details.velocity.pixelsPerSecond.dx > details.velocity.pixelsPerSecond.dy) {}
      },
      child: child,
    );
  }
}
