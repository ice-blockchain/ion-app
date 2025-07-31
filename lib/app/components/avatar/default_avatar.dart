// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class DefaultAvatar extends StatelessWidget {
  const DefaultAvatar({required this.size, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: size,
      height: size,
      color: context.theme.appColors.onTertararyFill,
      child: Assets.svg.iconProfileNoimage.icon(size: size * 0.8),
    );
  }
}
