import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_search_filters_page/feed_search_filter_languages.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_search_filters_page/feed_search_filter_people.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_text_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class FeedSearchFiltersPage extends ConsumerWidget {
  const FeedSearchFiltersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.feed_search_filter_title),
            actions: [
              NavigationTextButton(
                label: context.i18n.button_reset,
                onPressed: () {},
              ),
            ],
          ),
          ScreenSideOffset.small(
            child: Column(
              children: [
                FeedSearchFilterPeople(),
                SizedBox(height: 18.0.s),
                FeedSearchFilterLanguages(),
                SizedBox(height: 34.0.s),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.0.s),
                  child: Button(
                    mainAxisSize: MainAxisSize.max,
                    label: Text(context.i18n.button_apply),
                    onPressed: () {
                      // Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
          ScreenBottomOffset(margin: 32.0.s),
        ],
      ),
    );
  }
}
