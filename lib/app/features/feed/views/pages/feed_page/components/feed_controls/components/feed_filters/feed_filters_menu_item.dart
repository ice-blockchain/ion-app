// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class FeedFiltersMenuItem extends ConsumerWidget {
  const FeedFiltersMenuItem({
    required this.onPressed,
    required this.isSelected,
    required this.icon,
    required this.label,
    super.key,
  });

  final VoidCallback onPressed;
  final bool isSelected;
  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;

    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.s, vertical: 4.0.s),
        child: SizedBox(
          height: 36.0.s,
          child: Row(
            children: [
              icon,
              SizedBox(width: 7.0.s),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyles.subtitle3.copyWith(color: colors.primaryText),
                ),
              ),
              if (isSelected)
                IconAssetColored(
                  Assets.svgIconDappCheck,
                  color: colors.success,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
