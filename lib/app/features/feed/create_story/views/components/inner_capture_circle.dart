// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';

class InnerCaptureCircle extends StatelessWidget {
  const InnerCaptureCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 54.0.s,
      child: const DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}
