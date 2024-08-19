import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/pages/feed_main_modal/components/feed_modal_item.dart';
import 'package:ice/app/features/feed/views/pages/feed_main_modal/components/feed_modal_separator.dart';
import 'package:ice/app/features/wallet/model/feed_type.dart';
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
          const FeedModalSeparator(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: feedTypeValues.length,
            itemBuilder: (BuildContext context, int index) {
              return FeedModalItem(
                feedType: feedTypeValues[index],
                onTap: () {},
              );
            },
          ),
          SizedBox(height: 2.0.s),
        ],
      ),
    );
  }
}
