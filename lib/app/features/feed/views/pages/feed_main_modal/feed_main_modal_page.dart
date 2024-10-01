// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/separated/separator.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/pages/feed_main_modal/components/feed_modal_item.dart';
import 'package:ice/app/features/wallet/model/feed_type.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class FeedMainModalPage extends StatelessWidget {
  const FeedMainModalPage({super.key});

  static const List<FeedType> feedTypeValues = FeedType.values;

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.screen(
            title: Text(context.i18n.feed_modal_title),
            showBackButton: false,
          ),
          ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (_, __) => const HorizontalSeparator(),
            itemCount: feedTypeValues.length,
            itemBuilder: (BuildContext context, int index) {
              final type = feedTypeValues[index];
              return FeedModalItem(
                feedType: type,
                onTap: () {
                  final createFlowRouteLocation = _getCreateFlowRouteLocation(type);
                  context
                    ..go(GoRouterState.of(context).currentTab.baseRouteLocation)
                    ..go(createFlowRouteLocation);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  String _getCreateFlowRouteLocation(FeedType type) {
    switch (type) {
      case FeedType.post:
        return CreatePostRoute().location;
      case FeedType.story:
        return CreateStoryRoute().location;
      case FeedType.video:
        return CreateVideoRoute().location;
      case FeedType.article:
        return CreateArticleRoute().location;
    }
  }
}
