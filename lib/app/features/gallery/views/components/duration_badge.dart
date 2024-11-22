// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class DurationBadge extends StatelessWidget {
  const DurationBadge({
    required this.duration,
    super.key,
  });

  final int duration;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20.0.s,
      height: 20.0.s,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.theme.appColors.backgroundSheet,
          shape: BoxShape.circle,
          borderRadius: BorderRadius.circular(6.0.s),
        ),
        child: Center(
          child: Text(
            '$duration',
            style: context.theme.appTextThemes.caption.copyWith(
              color: context.theme.appColors.secondaryBackground,
              fontSize: 7.0.s,
            ),
          ),
        ),
      ),
    );
  }
}
