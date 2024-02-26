import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/iterable.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/components/feed_filters/feed_categories_dropdown.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/components/feed_filters/filters_separator.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/components/feed_filters/plus_button.dart';

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
          PlusButton(onPressed: () {}),
          Button.menu(
            onPressed: () {},
            label: Text(
              'For you',
              style: TextStyle(color: context.theme.appColors.primaryAccent),
            ),
            active: true,
          ),
          Button.menu(
            onPressed: () {},
            label: const Text(
              'Following',
            ),
          ),
          Button.menu(
            onPressed: () {},
            label: const Text(
              'Travel',
            ),
          ),
          Button.menu(
            onPressed: () {},
            label: const Text(
              'Programming',
            ),
          ),
        ].intersperse(const FiltersSeparator()).toList(),
      ),
    );
  }
}
