// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';

class EmptyList extends StatelessWidget {
  EmptyList({
    required this.asset,
    required this.title,
    super.key,
    double? imageSize,
  }) : imageSize = imageSize ?? 48.0.s;

  final String asset;
  final String title;
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          asset.icon(size: imageSize),
          SizedBox(height: 8.0.s),
          Text(
            title,
            style: context.theme.appTextThemes.caption2.copyWith(
              color: context.theme.appColors.tertararyText,
            ),
          ),
        ],
      ),
    );
  }
}
