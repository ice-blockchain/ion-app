// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    required this.iconAsset,
    required this.title,
    required this.description,
    super.key,
  });

  final String iconAsset;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        iconAsset.icon(size: 80.0.s),
        SizedBox(height: 10.0.s),
        Text(
          title,
          textAlign: TextAlign.center,
          style: context.theme.appTextThemes.title.copyWith(
            color: context.theme.appColors.primaryText,
          ),
        ),
        SizedBox(height: 8.0.s),
        Text(
          description,
          textAlign: TextAlign.center,
          style: context.theme.appTextThemes.body2.copyWith(
            color: context.theme.appColors.secondaryText,
          ),
        ),
      ],
    );
  }
}
