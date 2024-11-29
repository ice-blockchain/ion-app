// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class StoryHeaderGradient extends StatelessWidget {
  const StoryHeaderGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 80.0.s,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.theme.appColors.primaryText.withOpacity(0.3),
              context.theme.appColors.primaryText.withOpacity(0.15),
              context.theme.appColors.primaryText.withOpacity(0),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }
}
