// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';

class ReadTimeTile extends StatelessWidget {
  const ReadTimeTile({
    required this.minutesToRead,
    required this.borderRadius,
    super.key,
    this.alignment = AlignmentDirectional.bottomEnd,
  });

  final AlignmentDirectional alignment;

  final int minutesToRead;

  final double borderRadius;

  BorderRadiusGeometry _getOverlayBorderRadius(AlignmentDirectional alignment) {
    return switch (alignment) {
      AlignmentDirectional.bottomEnd ||
      AlignmentDirectional.topStart =>
        BorderRadiusDirectional.only(
          topStart: Radius.circular(borderRadius),
          bottomEnd: Radius.circular(borderRadius),
        ),
      AlignmentDirectional.topEnd ||
      AlignmentDirectional.bottomStart =>
        BorderRadiusDirectional.only(
          topEnd: Radius.circular(borderRadius),
          bottomStart: Radius.circular(borderRadius),
        ),
      _ => BorderRadius.all(Radius.circular(borderRadius))
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.0.s, vertical: 4.0.s),
      decoration: BoxDecoration(
        color: context.theme.appColors.tertararyBackground,
        border: Border.all(
          color: context.theme.appColors.onTertararyFill,
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
          SizedBox(width: 4.0.s),
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
