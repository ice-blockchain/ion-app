// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class OverlayMenuItemSeperator extends StatelessWidget {
  const OverlayMenuItemSeperator({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5.s,
      width: double.infinity,
      color: context.theme.appColors.onTerararyFill,
    );
  }
}
