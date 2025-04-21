// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class PostMediaIndexIndicator extends StatelessWidget {
  const PostMediaIndexIndicator({
    required this.currentIndex,
    required this.mediaCount,
    this.endPadding,
    super.key,
  });

  final int currentIndex;
  final int mediaCount;
  final double? endPadding;

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      top: 8.0.s,
      end: endPadding ?? 24.0.s,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6.0.s)),
          color: context.theme.appColors.backgroundSheet,
        ),
        padding: EdgeInsets.symmetric(horizontal: 4.0.s, vertical: 1.0.s),
        child: Text(
          '${currentIndex + 1}/$mediaCount',
          style: context.theme.appTextThemes.caption.copyWith(
            color: context.theme.appColors.primaryBackground,
          ),
        ),
      ),
    );
  }
}
