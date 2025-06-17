// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    required this.iconAsset,
    required this.title,
    this.description,
    this.descriptionWidget,
    this.descriptionTextAlign = TextAlign.center,
    super.key,
  }) : assert(
          description != null || descriptionWidget != null,
          'Either description or descriptionWidget must be provided.',
        );

  final String iconAsset;
  final String title;
  final String? description;
  final Widget? descriptionWidget;
  final TextAlign descriptionTextAlign;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconAsset(iconAsset, size: 80),
        SizedBox(height: 10.0.s),
        Text(
          title,
          textAlign: TextAlign.center,
          style: context.theme.appTextThemes.title.copyWith(
            color: context.theme.appColors.primaryText,
          ),
        ),
        SizedBox(height: 8.0.s),
        switch (descriptionWidget) {
          Widget() => descriptionWidget!,
          null when description != null => Text(
              description!,
              textAlign: descriptionTextAlign,
              style: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.secondaryText,
              ),
            ),
          _ => const SizedBox()
        },
      ],
    );
  }
}
