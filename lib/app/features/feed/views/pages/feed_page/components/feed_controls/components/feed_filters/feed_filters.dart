import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/components/feed_filters/components/feed_categories_dropdown.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/components/feed_filters/components/filters_separator.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/components/feed_filters/components/plus_button.dart';

class FeedFilters extends HookWidget {
  const FeedFilters();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding:
          EdgeInsets.symmetric(horizontal: ScreenSideOffset.defaultSmallMargin),
      child: Row(
        children: <Widget>[
          const FeedCategoriesDropdown(),
          const FiltersSeparator(),
          PlusButton(onPressed: () {}),
          const FiltersSeparator(),
          Button.menu(
            onPressed: () {},
            label: Text(
              'For you',
              style: TextStyle(color: context.theme.appColors.primaryAccent),
            ),
            active: true,
          ),
          const FiltersSeparator(),
          Button.menu(
            onPressed: () {},
            label: const Text(
              'Following',
            ),
          ),
          const FiltersSeparator(),
          Button.menu(
            onPressed: () {},
            label: const Text(
              'Travel',
            ),
          ),
          const FiltersSeparator(),
          Button.menu(
            onPressed: () {},
            label: const Text(
              'Programming',
            ),
          ),
        ],
      ),
    );
  }
}
