// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/shadow/svg_shadow.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class TrendingVideoMenuButton extends StatelessWidget {
  const TrendingVideoMenuButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.0.s,
      child: IconButton(
        onPressed: onPressed,
        icon: SvgShadow(
          child: Assets.svg.iconMorePopup.icon(
            size: 16.0.s,
            color: context.theme.appColors.onPrimaryAccent,
          ),
        ),
      ),
    );
  }
}
