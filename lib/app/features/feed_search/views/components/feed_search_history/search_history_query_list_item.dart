// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class FeedSearchHistoryQueryListItem extends ConsumerWidget {
  const FeedSearchHistoryQueryListItem({required this.query, required this.onTap, super.key});

  final String query;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.0.s,
          horizontal: ScreenSideOffset.defaultSmallMargin,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              query,
              style: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.primaryText,
              ),
            ),
            Assets.svg.iconSearchHistorylink.icon(size: 20.0.s),
          ],
        ),
      ),
    );
  }
}
