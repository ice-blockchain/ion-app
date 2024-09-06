import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class RepostOptionsModal extends StatelessWidget {
  const RepostOptionsModal({required this.postId, super.key});

  final String postId;

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NavigationAppBar.modal(
              showBackButton: false,
              title: Text(context.i18n.feed_repost_type),
              leading: NavigationCloseButton(onPressed: context.pop),
            ),
            SizedBox(height: 11.0.s),
            ScreenSideOffset.small(
              child: Button(
                type: ButtonType.secondary,
                mainAxisSize: MainAxisSize.max,
                onPressed: () {},
                leadingIcon: Assets.svg.iconFeedRepost.icon(size: 18.0.s),
                leadingIconOffset: 12.0.s,
                label: Text(
                  context.i18n.feed_repost,
                ),
              ),
            ),
            SizedBox(height: 16.0.s),
            ScreenSideOffset.small(
              child: Button(
                type: ButtonType.secondary,
                mainAxisSize: MainAxisSize.max,
                onPressed: () {
                  CommentPostModalRoute(postId: postId).pushReplacement(context);
                },
                leadingIcon: Assets.svg.iconFeedQuote.icon(size: 18.0.s),
                leadingIconOffset: 12.0.s,
                label: Text(
                  context.i18n.feed_quote_post,
                ),
              ),
            ),
            SizedBox(height: 20.0.s),
          ],
        ),
      ),
    );
  }
}
