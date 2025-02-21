// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class VideoGradientOverlay extends StatelessWidget {
  const VideoGradientOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0, -0.96),
          end: const Alignment(0, 0.96),
          stops: const [0.0153, 0.4865, 0.8724],
          colors: [
            context.theme.appColors.primaryText.withValues(alpha: 0),
            context.theme.appColors.primaryText.withValues(alpha: 0.71),
            context.theme.appColors.primaryText.withValues(alpha: 1),
          ],
        ),
      ),
    );
  }
}
