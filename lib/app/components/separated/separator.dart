// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class HorizontalSeparator extends StatelessWidget {
  const HorizontalSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.theme.appColors.secondaryBackground,
            context.theme.appColors.onTerararyFill,
            context.theme.appColors.secondaryBackground,
          ],
          stops: const [
            0.0,
            0.5,
            1.0,
          ],
        ),
      ),
    );
  }
}
