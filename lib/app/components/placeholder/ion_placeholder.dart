// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class IonPlaceholder extends StatelessWidget {
  const IonPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.theme.appColors.tertararyBackground,
      child: Center(
        child: Assets.svg.iconFeedUnavailable.icon(
          size: 40.0.s,
          color: context.theme.appColors.sheetLine,
        ),
      ),
    );
  }
}
