// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class FeedSearchHistoryEmpty extends StatelessWidget {
  const FeedSearchHistoryEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScreenSideOffset.small(
        child: Column(
          children: [
            SizedBox(height: 150.0.s),
            Assets.svg.walletIconWalletSearching.icon(size: 48.0.s),
            SizedBox(height: 8.0.s),
            Text(
              context.i18n.feed_search_empty,
              style: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.tertararyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
