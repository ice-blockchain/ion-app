import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/pages/feed_main_modal/components/feed_modal_item.dart';
import 'package:ice/app/features/feed/views/pages/feed_main_modal/components/feed_modal_separator.dart';
import 'package:ice/app/features/wallet/model/feed_type.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class FeedMainModalPage extends IcePage {
  const FeedMainModalPage({super.key});

  static const List<FeedType> feedTypeValues = FeedType.values;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: ScreenSideOffset.small(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              NavigationAppBar.screen(
                title: context.i18n.feed_modal_title,
                showBackButton: false,
              ),
              const FeedModalSeparator(),
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 10.0.s),
                itemCount: feedTypeValues.length,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 12.0.s,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return ScreenSideOffset.small(
                    child: FeedModalItem(
                      feedType: feedTypeValues[index],
                      onTap: () {},
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
