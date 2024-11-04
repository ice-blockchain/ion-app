// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class FeedItemMenuItem extends StatelessWidget {
  const FeedItemMenuItem({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String label;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;

    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        height: 42.0.s,
        width: 186.0.s,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.s),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyles.subtitle3.copyWith(color: colors.primaryText),
                ),
              ),
              icon,
            ],
          ),
        ),
      ),
    );
  }
}
