// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class ReadTimeTile extends StatelessWidget {
  const ReadTimeTile({
    required this.minutesToRead,
    required this.borderRadius,
    super.key,
    this.alignment = Alignment.bottomRight,
  });

  final Alignment alignment;

  final int minutesToRead;

  final double borderRadius;

  BorderRadius _getOverlayBorderRadius(Alignment alignment) {
    return switch (alignment) {
      Alignment.bottomRight || Alignment.topLeft => BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      Alignment.topRight || Alignment.bottomLeft => BorderRadius.only(
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
        ),
      _ => BorderRadius.all(Radius.circular(borderRadius))
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0.s, vertical: 4.0.s),
      decoration: BoxDecoration(
        color: context.theme.appColors.tertararyBackground,
        border: Border.all(
          color: context.theme.appColors.onTerararyFill,
        ),
        borderRadius: _getOverlayBorderRadius(alignment),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            size: 16.0.s,
            color: context.theme.appColors.sharkText,
          ),
          SizedBox(width: 3.0.s),
          Text(
            context.i18n.feed_read_time_in_mins(minutesToRead),
            style: context.theme.appTextThemes.caption
                .copyWith(color: context.theme.appColors.sharkText),
          ),
        ],
      ),
    );
  }
}
