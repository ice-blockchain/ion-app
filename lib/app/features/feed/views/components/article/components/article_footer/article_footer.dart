// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/theme_data.dart';

class ArticleFooter extends StatelessWidget {
  const ArticleFooter({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          context.theme.appTextThemes.subtitle3.copyWith(color: context.theme.appColors.sharkText),
    );
  }
}
