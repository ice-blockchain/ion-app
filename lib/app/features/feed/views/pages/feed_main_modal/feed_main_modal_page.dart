import 'package:flutter/material.dart';
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
            separatorBuilder: (_, __) => HorizontalSeparator(),
            itemCount: feedTypeValues.length,
            itemBuilder: (BuildContext context, int index) {
              final FeedType type = feedTypeValues[index];
              return FeedModalItem(
                feedType: type,
                onTap: () {
                  final actions = {
                    FeedType.post: () => null,
                    FeedType.story: () => CreateStoryRoute().go(context),
                    FeedType.video: () => CreateVideoRoute().go(context),
                    FeedType.article: () => CreateArticleRoute().go(context),
                  };

                  actions[type]?.call();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
