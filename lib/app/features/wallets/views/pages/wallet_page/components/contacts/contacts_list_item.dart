// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';

class ContactsListItem extends StatelessWidget {
  const ContactsListItem({
    required this.imageUrl,
    required this.label,
    required this.onTap,
    super.key,
  });

  final String imageUrl;
  final String label;
  final VoidCallback onTap;

  static double get width => 70.0.s;

  static double get imageWidth => 60.0.s;

  static double get height => 84.0.s;

  static double get iceLogoSize => 20.0.s;

  static double get iceLogoBorderRadius => 8.0.s;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Avatar(
              size: imageWidth,
              imageUrl: imageUrl,
              borderRadius: BorderRadius.circular(14.0.s),
            ),
            Text(
              label,
              style: context.theme.appTextThemes.caption.copyWith(
                color: context.theme.appColors.secondaryText,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
