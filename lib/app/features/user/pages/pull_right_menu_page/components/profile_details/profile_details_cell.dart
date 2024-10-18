// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/progress_bar/ice_loading_indicator.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/theme_data.dart';

class ProfileDetailsCell extends StatelessWidget {
  const ProfileDetailsCell({
    required this.title,
    required this.value,
    super.key,
  });

  final String title;
  final int? value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: context.theme.appTextThemes.caption3.copyWith(
            color: context.theme.appColors.tertararyText,
          ),
        ),
        if (value == null)
          const IceLoadingIndicator(type: IndicatorType.dark)
        else
          Text(
            value.toString(),
            style: context.theme.appTextThemes.title.copyWith(
              color: context.theme.appColors.primaryText,
            ),
          ),
      ],
    );
  }
}
