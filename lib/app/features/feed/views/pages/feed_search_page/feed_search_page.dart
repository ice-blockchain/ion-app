import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_top_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/pages/feed_search_page/components/feed_search_navigation.dart';
import 'package:ice/generated/assets.gen.dart';

class FeedSearchPage extends StatelessWidget {
  const FeedSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenTopOffset(
        child: Column(
          children: [
            FeedSearchNavigation(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Assets.images.icons.walletIconWalletSearching.icon(size: 48.0.s),
                  SizedBox(height: 8.0.s),
                  Text(
                    context.i18n.feed_search_empty,
                    style: context.theme.appTextThemes.body2.copyWith(
                      color: context.theme.appColors.tertararyText,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
