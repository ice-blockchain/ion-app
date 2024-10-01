// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';

class LinksListTileIcon extends StatelessWidget {
  const LinksListTileIcon({
    required this.iconAssetName,
    required this.iconTintColor,
    super.key,
  });

  final String iconAssetName;
  final Color iconTintColor;

  double get containerSize => 36.0.s;

  double get iconSize => 20.0.s;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        color: context.theme.appColors.secondaryBackground,
        border: Border.all(
          color: context.theme.appColors.onTerararyFill,
        ),
        borderRadius: BorderRadius.circular(12.0.s),
      ),
      child: iconAssetName.icon(
        size: iconSize,
        color: iconTintColor,
      ),
    );
  }
}
