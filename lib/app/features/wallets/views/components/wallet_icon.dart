// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class WalletIcon extends StatelessWidget {
  const WalletIcon({
    this.size = 36.0,
    this.borderRadius = 10.0,
    this.iconSize = 24.0,
    super.key,
  });

  final double size;
  final double borderRadius;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.s,
      height: size.s,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius.s),
        color: context.theme.appColors.darkBlue,
      ),
      child: Center(
        child: SizedBox(
          width: iconSize.s,
          height: iconSize.s,
          child: IconAsset(Assets.svgIconWallet, size: iconSize),
        ),
      ),
    );
  }
}
