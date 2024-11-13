// SPDX-License-Identifier: ice License 1.0

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class StoryControlButton extends StatelessWidget {
  const StoryControlButton({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0.s),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.theme.appColors.primaryText.withOpacity(0.5),
            ),
            child: Padding(
              padding: EdgeInsets.all(6.0.s),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}
