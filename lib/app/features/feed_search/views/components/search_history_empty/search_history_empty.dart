// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class SearchHistoryEmpty extends StatelessWidget {
  const SearchHistoryEmpty({required this.title, super.key});

  final String title;

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
              title,
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
