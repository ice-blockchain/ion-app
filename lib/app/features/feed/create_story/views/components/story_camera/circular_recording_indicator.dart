// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';

class CircularRecordingIndicator extends StatelessWidget {
  const CircularRecordingIndicator({
    required this.progress,
    super.key,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 90.0.s,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: CircularProgressIndicator(
          value: progress,
          strokeWidth: 2.0.s,
          valueColor: AlwaysStoppedAnimation<Color>(context.theme.appColors.primaryAccent),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
