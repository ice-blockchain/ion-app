// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';

class TabIcon extends StatelessWidget {
  const TabIcon({
    required this.icon,
    required this.isSelected,
    super.key,
  });

  final String icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0.s,
      child: IconAssetColored(
        icon,
        size: 24.0,
        fit: BoxFit.none,
        color: isSelected
            ? context.theme.appColors.primaryAccent
            : context.theme.appColors.tertararyText,
      ),
    );
  }
}
