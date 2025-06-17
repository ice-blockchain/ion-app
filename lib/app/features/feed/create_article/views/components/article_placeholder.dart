// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class ArticlePlaceholder extends StatelessWidget {
  const ArticlePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 36.0.s,
          height: 36.0.s,
          decoration: BoxDecoration(
            color: context.theme.appColors.primaryAccent,
            borderRadius: BorderRadius.circular(18.0.s),
          ),
          alignment: Alignment.center,
          child: IconAsset(Assets.svgIconLoginCamera, size: 24.0),
        ),
        SizedBox(height: 7.0.s),
        Text(
          context.i18n.create_article_add_cover,
          style: context.theme.appTextThemes.body2.copyWith(
            color: context.theme.appColors.primaryText,
          ),
        ),
      ],
    );
  }
}
